defmodule ExBinance.Market.PriceLevelTest do
  use ExUnit.Case

  alias ExBinance.Market.PriceLevel

  test "creates a PriceLevel from a 3 element array" do
    level = PriceLevel.new(["0.00187260", "637.71000000", []])
    assert level == %PriceLevel{price: Decimal.new("0.00187260"), quantity: Decimal.new("637.71000000")}
  end
end
