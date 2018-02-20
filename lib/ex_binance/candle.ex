defmodule ExBinance.Candle do
  def build_series([head | rest]) do
    [build_single(head) | build_series(rest)]
  end

  def build_series([]) do
    []
  end

  def build_single([open_time, open, high, low, close, volume,
             close_time, quote_volume, trades, taker_base_vol, taker_quote_vol, _]) do
    %{
      open_time: parse_timestamp(open_time),
      close_time: parse_timestamp(close_time),
      open: Decimal.new(open),
      high: Decimal.new(high),
      low: Decimal.new(low),
      close: Decimal.new(close),
      base_volume: Decimal.new(volume),
      quote_volume: Decimal.new(quote_volume),
      trades: trades
    }
  end

  defp parse_timestamp(ts) do
    ts |> DateTime.from_unix!(:milliseconds)
  end
end
