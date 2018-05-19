defmodule ExBinance.Market do
  use ExBinance.ApiClient

  alias ExBinance.Exchange

  defstruct [
    base_currency: nil,
    quote_currency: nil,
    status: nil,
    base_precision: nil,
    quote_precision: nil,
    iceberg_allowed: false
  ]

  alias __MODULE__

  @field_mappings [
    {"baseAsset", :base_currency},
    {"quoteAsset", :quote_currency},
    {"status", :status},
    {"baseAssetPrecision", :base_precision},
    {"quotePrecision", :quote_precision},
    {"icebergAllowed", :iceberg_allowed}
  ]

  def new(markets) when is_list(markets) do
    Enum.map(markets, &new/1)
  end

  def new(market) when is_map(market) do
    fields = Enum.map(@field_mappings, &(map_field(&1, market)))
    struct(Market, fields)
  end

  def all() do
    Exchange.info().markets
    |> Market.new()
  end

  def all_quoted_by(currency), do: Enum.filter(all(), &(is_quoted_by?(&1, currency)))
  def all_based_on(currency), do: Enum.filter(all(), &(is_based_on?(&1, currency)))

  defp is_based_on?(market, currency), do: market.base_currency == String.upcase(currency)
  defp is_quoted_by?(market, currency), do: market.quote_currency == String.upcase(currency)
  defp map_field({src_key, dst_key}, market), do: {dst_key, market[src_key]}
end
