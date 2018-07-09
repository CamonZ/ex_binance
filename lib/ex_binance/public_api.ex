defmodule ExBinance.PublicApi do
  alias ExBinance.{Candle, Market}

  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.binance.com/api")
  plug(Tesla.Middleware.JSON)

  @valid_depth_limits [5, 10, 20, 50, 100, 500, 1000]
  @valid_candle_interval ["1m", "3m", "5m", "15m", "30m", "1h", "2h", "4h",
                          "6h", "8h", "12h", "1d", "3d", "1w", "1M"]

  def get_historical_trades(market) when is_bitstring(market) do
    get_historical_trades(%{symbol: market})
  end

  def get_historical_trades(args) when is_map(args) do
    get("/v1/historicalTrades", query: serialize(args)).body
  end

  def get_historical_trades(_) do
    raise ArgumentError
  end

  def get_aggregate_trades(market) when is_bitstring(market) do
    get_aggregate_trades(%{symbol: market})
  end

  def get_aggregate_trades(args) when is_map(args) do
    get("/v1/aggTrades", query: serialize(args)).body
  end

  def get_aggregate_trades(_) do
    raise ArgumentError
  end

  def get_candle_data(market, interval, limit \\ 500) when is_bitstring(market) and interval in @valid_candle_interval and is_integer(limit) do
    get_candle_data(%{symbol: market, interval: interval, limit: limit})
  end

  def get_candle_data(%{symbol: market, interval: interval} = args) when is_bitstring(market) and interval in @valid_candle_interval do
    get("/v1/klines", query: serialize(args)).body |> Candle.build_series()
  end

  def get_candle_data(_) do
    raise ArgumentError
  end

  def get_ticker() do
    get_ticker(%{symbol: nil})
  end

  def get_ticker(symbol) when is_bitstring(symbol) do
    get_ticker(%{symbol: symbol})
  end

  def get_ticker(args) do
    get("/v1/ticker/24hr", query: serialize(args)).body
  end

  # Helper functions

  defp serialize(args) do
    args
    |> camelize_keys()
    |> Enum.filter(fn({_, v}) -> v != nil end)
    |> Enum.into(%{})
  end

  defp camelize_keys(args) do
    args
    |> Enum.map(fn({k, v}) -> {camelize_key(k), v} end)
  end

  defp camelize_key(key) when is_atom(key) do
    key
    |> Atom.to_string()
    |> camelize_key()
  end

  defp camelize_key(key) when is_bitstring(key) do
    [head | rest] =  String.split(key, "_")
    [head | Enum.map(rest, &String.capitalize/1)]
    |> Enum.join()
  end
end
