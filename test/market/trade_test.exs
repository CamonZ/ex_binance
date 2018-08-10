defmodule ExBinance.Market.TradeTest do
  use ExUnit.Case

  alias ExBinance.Market.Trade
  alias ExBinance.Market

  describe "new" do
    test "builds a list of trades from the rest API" do
      market = %Market{
        base_currency: "BNB",
        quote_currency: "BTC"
      }

      data = %{
        "id" => 28457,
        "price" => "4.01",
        "qty" => "12.0",
        "time" => 1499865549590,
        "isBuyerMaker" => true,
        "isBestMatch" => true
      }

      trades = [data, data]

      [%Trade{} = t, %Trade{} = t] = Trade.new(trades, market)

      assert t == t
    end


    test "builds a single trade from the rest API" do
      market = %Market{
        base_currency: "BNB",
        quote_currency: "BTC"
      }

      data = %{
        "id" => 28457,
        "price" => "4.01",
        "qty" => "12.0",
        "time" => 1499865549590,
        "isBuyerMaker" => true,
        "isBestMatch" => true
      }

      trade = Trade.new(data, market)

      assert trade == %Trade{
        id: 28457,
        price: Decimal.new("4.01"),
        size: Decimal.new("12.0"),
        symbol: "BNBBTC",
        time: DateTime.from_unix!(1499865549590, :millisecond),
        is_buyer_maker: true,
        is_best_match: true
      }
    end

    test "builds a single trade from the websockets API" do
      data = %{
        "e" => "trade",
        "E" => 123456789,
        "s" => "BNBBTC",
        "t" => 28457,
        "p" => "4.01",
        "q" => "12.0",
        "b" => 88,
        "a" => 50,
        "T" => 1499865549590,
        "m" => true,
        "M" => true
      }

      trade = Trade.new(data)

      assert trade == %Trade{
        id: 28457,
        price: Decimal.new("4.01"),
        size: Decimal.new("12.0"),
        symbol: "BNBBTC",
        time: DateTime.from_unix!(1499865549590, :millisecond),
        is_buyer_maker: true,
        is_best_match: nil
      }
    end
  end
end
