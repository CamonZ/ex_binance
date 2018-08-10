defmodule ExBinance.Market.PriceLevel do
  defstruct price: nil, quantity: nil

  def new([price, quantity, _]) do
    %__MODULE__{
      price: Decimal.new(price),
      quantity: Decimal.new(quantity)
    }
  end
end
