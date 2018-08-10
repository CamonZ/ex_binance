defmodule ExBinance.Market.StreamServerTest do
  use ExUnit.Case

  alias ExBinance.Market.StreamServer
  alias ExBinance.{Market, Market.StreamServer, Market.Trade, Market.DepthUpdate, Market.PriceLevel}
  alias ExBinance.Market.StreamServerTest.{TradeMessageHandler, DepthUpdateMessageHandler}

  test "returns and {:ok, pid} tuple when called with a Market" do
    market = %Market{
      base_currency: "BNB",
      quote_currency: "BTC"
    }

    {:ok, pid} = StreamServer.start_link(market, {ExBinance.Market.StreamServerTest, :handle_message})

    assert is_pid(pid)
  end

  test "returns {:error, reason} when not called with a market" do
    {:error, reason} = StreamServer.start_link(%{})
    assert reason == :argument_needs_to_be_market
  end

  describe "handle_frame/2" do
    test "deserializes a trade frame into a Trade struct" do
      msg = load_message("trade")
      old_state = %{callback: {TradeMessageHandler, :handle_message}}

      {:ok, state} = StreamServer.handle_frame({nil, msg}, old_state)

      assert state == old_state
    end


    test "deserializes a delta update frame into a DeltaUpdate struct" do
      msg = load_message("depth")
      old_state = %{callback: {DepthUpdateMessageHandler, :handle_message}}

      {:ok, state} = StreamServer.handle_frame({nil, msg}, old_state)

      assert state == old_state
    end
  end

  defmodule TradeMessageHandler do
    def handle_message(data) do
      %Trade{price: price, size: size, symbol: "BNBBTC"} = data

      assert price == Decimal.new("0.001")
      assert size == Decimal.new("100")
    end
  end

  defmodule DepthUpdateMessageHandler do
    def handle_message(data) do
      %DepthUpdate{bids: [bid], asks: [ask], time: time} = data

      assert time == DateTime.from_unix!(1533861081044, :millisecond)
      assert bid == PriceLevel.new(["0.0024","10",[]])
      assert ask == PriceLevel.new(["0.0026","100",[]])
    end
  end

  defp load_message(msg_name) do
    data = "test/support"
    |> Path.join("#{msg_name}_message.json")
    |> File.read!

    "{\"stream\": \"BNBBTC\", \"data\": #{data}}"
  end
end
