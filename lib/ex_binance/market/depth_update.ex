defmodule ExBinance.Market.DepthUpdate do
  alias ExBinance.Market.PriceLevel
  alias __MODULE__

  defstruct [
    time: nil,
    symbol: nil,
    first_update_id: nil,
    last_update_id: nil,
    bids: [],
    asks: []
  ]

  def new(%{"E" => time, "a" => asks, "b" => bids, "s" => symbol, "U" => first, "u" => last}) do
    %__MODULE__{
      time: DateTime.from_unix!(time, :millisecond),
      symbol: symbol,
      first_update_id: first,
      last_update_id: last,
      bids: Enum.map(bids, &PriceLevel.new/1),
      asks: Enum.map(asks, &PriceLevel.new/1)
    }
  end
end
