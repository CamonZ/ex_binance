defmodule ExBinance.Market.Trade do

  alias __MODULE__
  alias ExBinance.Market

  defstruct [
    id: nil,
    price: nil,
    size: nil,
    time: nil,
    symbol: nil,
    is_buyer_maker: nil,
    is_best_match: nil

  ]

  def new(data, %Market{} = market) when is_list(data) do
    Enum.map(data, &(Trade.new(&1, market)))
  end

  def new(%{"id" => id, "price" => p, "qty" => q, "time" => t, "isBuyerMaker" => m, "isBestMatch" =>  mm}, market) do
    %Trade{
      id: id,
      price: Decimal.new(p),
      size: Decimal.new(q),
      time: DateTime.from_unix!(t, :millisecond),
      symbol: Market.full_name(market),
      is_buyer_maker: m,
      is_best_match: mm,
    }
  end

  def new(%{"s" => s, "t" => t, "p" => p, "q" => q, "b" => b, "a" => a, "T" => tt, "m" => m}) do
    %Trade{
      id: t,
      price: Decimal.new(p),
      size: Decimal.new(q),
      time: DateTime.from_unix!(tt, :millisecond),
      symbol: s,
      is_buyer_maker: m,
      is_best_match: nil
    }
  end
end
