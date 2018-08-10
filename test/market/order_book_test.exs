defmodule ExBinance.Market.OrderBookTest do
  use ExUnit.Case

  alias ExBinance.Market.{OrderBook, PriceLevel}

  test "creates an OrderBook from a map" do
    data = %{
      "lastUpdateId" => 1027024,
      "bids" => [["0.0024", "10", []]],
      "asks" => [["0.0026", "100", []]]
    }

    delta = OrderBook.new(data)

    assert delta == %OrderBook{
      last_update_id: 1027024,
      bids: [
        %PriceLevel{price: Decimal.new("0.0024"), quantity: Decimal.new("10")}
      ],
      asks: [
        %PriceLevel{price: Decimal.new("0.0026"), quantity: Decimal.new("100")}
      ]
    }
  end
end
