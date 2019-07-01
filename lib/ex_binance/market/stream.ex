defmodule ExBinance.Market.Stream do
  require Logger

  use WebSockex

  alias ExBinance.Market

  defstruct [
    markets: [],
    streams: [],
    callback: nil
  ]

  @valid_streams ["trade", "depth@100ms"]

  def start_link(%Market{} = market, callback) do
    start_link(market, callback, @valid_streams)
  end

  def start_link(%Market{} = market, callback, stream) when stream in @valid_streams do
    start_link(market, [stream])
  end

  def start_link(%Market{} = market, callback, streams) when is_list(streams) do
    state = %__MODULE__{
      markets: [sanitized_market_name(market)],
      callback: callback,
      streams: streams
    }

    WebSockex.start_link(
      endpoint(state),
      __MODULE__,
      state
    )
  end

  def start_link(markets, callback) when is_list(markets) do
    state = %__MODULE__{
      markets: Enum.map(markets, &sanitized_market_name/1),
      callback: callback,
      streams: @valid_streams
    }

    WebSockex.start_link(
      endpoint(state),
      __MODULE__,
      state
    )
  end

  def start_link(_) do
    {:error, :argument_needs_to_be_market}
  end

  def handle_frame({_type, msg}, %{callback: {m, f}} = state) do
    %{"data" => %{"e" => type} = data, "stream" => stream} = Poison.decode!(msg)

    parsed_data = case type do
                    "depthUpdate" ->
                      Market.DepthUpdate.new(data)
                    "trade" ->
                      Market.Trade.new(data)
                  end

    # apply(m, f, [parsed_data])

    Logger.info("Received: #{inspect(parsed_data)}")

    {:ok, state}
  end

  def sanitized_market_name(%Market{} = market) do
    market
    |> Market.full_name()
    |> String.downcase()
  end

  defp endpoint(%__MODULE__{} = state) do
    "wss://stream.binance.com:9443/stream?streams=#{stream_names(state)}"
  end

  def stream_names(%{markets: markets, streams: stream_names}) do
    streams =
      markets
      |> Enum.map(fn market -> Enum.map(stream_names, fn stream -> "#{market}@#{stream}" end) end)
      |> List.flatten()
      |> Enum.join("/")
  end
end
