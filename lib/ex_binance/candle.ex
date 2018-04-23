defmodule ExBinance.Candle do

  alias __MODULE__

  defstruct open_time: nil,
    close_time: nil,
    open: nil,
    high: nil,
    low: nil,
    close: nil,
    base_volume: nil,
    quote_volume: nil,
    trades: nil

  @type t :: %Candle{
    open_time: DateTime.t,
    close_time: DateTime.t,
    open: Decimal.t,
    high: Decimal.t,
    low: Decimal.t,
    close: Decimal.t,
    base_volume: Decimal.t,
    quote_volume: Decimal.t,
    trades: pos_integer
  }

  def build_series([head | rest]) do
    [build_single(head) | build_series(rest)]
  end

  def build_series([]) do
    []
  end

  def build_single([open_time, open, high, low, close, volume, close_time, quote_volume, trades, _, _, _]) do
    %Candle{
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

  defp parse_timestamp(ts), do: DateTime.from_unix!(ts, :milliseconds)
end
