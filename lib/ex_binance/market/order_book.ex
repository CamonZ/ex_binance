defmodule ExBinance.Market.OrderBook do
  use ExBinance.ApiClient

  alias ExBinance.Market
  alias __MODULE__

  defstruct [
    last_update_id: nil,
    bids: nil,
    asks: nil
  ]

  def new(%{"bids" => bids, "asks" => asks, "lastUpdateId" => id}) do
    %__MODULE__{last_update_id: id, bids: build_side(bids), asks: build_side(asks)}
  end

  def new(_) do
    %__MODULE__{}
  end

  defp build_side(side) do
    Enum.reduce(side, %{}, fn ([p, s, _], acc) -> put_in(acc, [p], s) end)
  end
end
