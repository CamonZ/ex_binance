defmodule ExBinance.Market.OrderBook do
  alias ExBinance.Market
  alias ExBinance.Market.PriceLevel
  alias __MODULE__

  defstruct [
    last_update_id: nil,
    bids: nil,
    asks: nil
  ]

  def new(%{"bids" => bids, "asks" => asks, "lastUpdateId" => id}) do
    %__MODULE__{
      last_update_id: id,
      bids: Enum.map(bids, &PriceLevel.new/1),
      asks: Enum.map(asks, &PriceLevel.new/1)
    }
  end
end
