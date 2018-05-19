defmodule ExBinance.Exchange do
  use ExBinance.ApiClient

  defstruct [
    timezone: nil,
    server_time: nil,
    rate_limits: [],
    exchange_filters: [],
    markets: []
  ]

  alias __MODULE__
  alias ExBinance.Exchange.RateLimit
  alias ExBinance.Market

  def ping do
    case get("/ping").body == {} do
      true -> :ok
      false -> {:error, :cant_connect_to_api}
    end
  end

  def current_time do
    get("/v1/time").body
    |> Map.get("serverTime")
    |> parse_timestamp()
  end

  def info() do
    get("/v1/exchangeInfo").body
    |> new()
  end

  def new(%{"timezone" => tz, "serverTime" => ts, "rateLimits" => lims, "symbols" => syms}) do
    %Exchange{
      timezone: tz,
      server_time: parse_timestamp(ts),
      rate_limits: RateLimit.new(lims),
      markets: Market.new(syms)
    }
  end

  defp parse_timestamp(timestamp), do: DateTime.from_unix!(timestamp, :milliseconds)
end

