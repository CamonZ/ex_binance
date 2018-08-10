defmodule ExBinance.Market.StreamServer do
  use WebSockex

  alias ExBinance.Market

  defstruct [
    market: nil,
    streams: [],
    callback: nil
  ]

  @valid_streams ["trade", "depth"]

  def start_link(%Market{} = market, callback) do
    start_link(market, callback, @valid_streams)
  end

  def start_link(%Market{} = market, callback, stream) when stream in @valid_streams do
    start_link(market, [stream])
  end

  def start_link(%Market{} = market, callback, streams) when is_list(streams) do
    state = %__MODULE__{
      market: sanitized_market_name(market),
      callback: callback,
      streams: streams
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

    apply(m, f, [parsed_data])

    {:ok, state}
  end

  defp sanitized_market_name(%Market{} = market) do
    market
    |> Market.full_name()
    |> String.downcase()
  end

  defp endpoint(%__MODULE__{} = state) do
    "wss://stream.binance.com:9443/stream?streams=#{streams_names(state)}"
  end

  defp streams_names(%__MODULE__{market: market_name, streams: stream_names}) do
    stream_names
    |> Enum.map(&("#{market_name}@#{&1}"))
    |> Enum.join("/")
  end
end
