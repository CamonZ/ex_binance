defmodule ExBinance.Market.Trade do

  alias __MODULE__
  alias ExBinance.Market

  defstruct [
    id: nil,
    price: nil,
    size: nil,
    time: nil,
    is_buyer_maker: nil,
    is_best_match: nil
  ]

  def new(data) when is_list(data) do
    Enum.map(data, &new/1)
  end

  def new(data) when is_map(data) do
    %Trade{
      id: data["id"],
      price: data["price"],
      size: data["qty"],
      time: data["time"],
      is_buyer_maker: data["isBuyerMaker"],
      is_best_match: data["isBestMatch"]
    }
  end

  def recent(%Market{} = market) do
  end
end
