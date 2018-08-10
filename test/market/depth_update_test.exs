defmodule ExBinance.Market.DepthUpdateTest do
  use ExUnit.Case

  alias ExBinance.Market.{DepthUpdate, PriceLevel}

  test "creates a DepthUpdate from a map" do
    data = %{
      "e" => "depthUpdate",
      "E" => 1533419917780,
      "s" => "BNBBTC",
      "U" => 157,
      "u" => 160,
      "b" => [["0.0024", "10", []]],
      "a" => [["0.0026", "100", []]]
    }

    delta = DepthUpdate.new(data)

    assert delta == %DepthUpdate{
      time: DateTime.from_unix!(1533419917780, :millisecond),
      symbol: "BNBBTC",
      first_update_id: 157,
      last_update_id: 160,
      bids: [
        %PriceLevel{price: Decimal.new("0.0024"), quantity: Decimal.new("10")}
      ],
      asks: [
        %PriceLevel{price: Decimal.new("0.0026"), quantity: Decimal.new("100")}
      ]
    }
  end
end
