defmodule ExBinance.Market.StreamServer do
  use WebSockex

  alias ExBinance.Market

  defstruct [
    market: nil,
    streams: []
  ]

  @valid_streams ["trade", "depth", "ticker"]

  def start_link(%Market{} = market) do
    start_link(market, @valid_streams)
  end

  def start_link(%Market{} = market, stream) when stream in @valid_streams do
    start_link(market, [stream])
  end

  def start_link(%Market{} = market, streams) when is_list(streams) do
    state = %__MODULE__{
      market: sanitized_market_name(market),
      streams: streams
    }

    WebSockex.start_link(
      endpoint(state),
      __MODULE__,
      state
    )
  end

  def handle_frame({_type, _msg}, state) do
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
