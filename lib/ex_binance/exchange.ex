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
    case get("/v3/ping") do
      {:ok, %{body: %{}}} -> :ok
      _foo -> {:error, :cant_connect_to_api}
    end
  end

  def current_time do
    with {:ok, %{body: body, status: 200}} <- get("/v3/time") do
      body
      |> Map.get("serverTime")
      |> parse_timestamp()
    end
  end

  def info() do
    with {:ok, %{body: body, status: 200}} <- get("/v3/exchangeInfo") do
      new(body)
    else
      _ -> {:error, :cant_connect_to_api}
    end
  end

  def markets do
    info().markets
  end

  def new(%{"timezone" => tz, "serverTime" => ts, "rateLimits" => lims, "symbols" => syms}) do
    %Exchange{
      timezone: tz,
      server_time: parse_timestamp(ts),
      rate_limits: RateLimit.new(lims),
      markets: Market.new(syms)
    }
  end

  defp parse_timestamp(timestamp), do: DateTime.from_unix!(timestamp, :millisecond)
end
