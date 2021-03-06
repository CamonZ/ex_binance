defmodule ExBinance.Market do
  use ExBinance.ApiClient

  alias ExBinance.{Market.OrderBook, Market.Trade}
  alias __MODULE__

  @derive Jason.Encoder
  defstruct [
    base_currency: nil,
    quote_currency: nil,
    status: nil,
    base_precision: nil,
    quote_precision: nil,
    iceberg_allowed: false,
    filters: nil,
    order_types: nil
  ]

  @field_mappings [
    {"baseAsset", :base_currency},
    {"quoteAsset", :quote_currency},
    {"status", :status},
    {"baseAssetPrecision", :base_precision},
    {"quotePrecision", :quote_precision},
    {"icebergAllowed", :iceberg_allowed}
  ]

  @valid_depth_limits [5, 10, 20, 50, 100, 500, 1000]

  def new(markets) when is_list(markets) do
    Enum.map(markets, &new/1)
  end

  def new(market) when is_map(market) do
    fields = Enum.map(@field_mappings, &(map_field(&1, market)))

    Market
    |> struct(fields)
    |> Map.put(:filters, market["filters"])
    |> Map.put(:order_types, market["orderTypes"])
  end

  def full_name(%Market{base_currency: base_cur, quote_currency: quote_cur}) do
    "#{base_cur}#{quote_cur}"
  end

  def depth(%Market{} = market, limit \\ 100) when limit in @valid_depth_limits do
    opts = [query: %{symbol: full_name(market), limit: limit}]

    with {:ok, %{body: body, status: 200}} <- get("/v3/depth", opts) do
      OrderBook.new(body)
    end
  end

  def trades(%Market{} = market) do
    opts = [query: %{symbol: full_name(market)}]
    with {:ok, %{body: body, status: 200}} <- get("/v3/trades", opts) do
      Trade.new(body, market)
    end
  end

  def ticker(%Market{} = market) do
    opts = [query: %{symbol: full_name(market)}]

    with {:ok, %{body: body, status: 200}} = r <- get("/v3/ticker/24hr", opts) do
      body
    else
      _ ->
        {:error, :cant_connect_to_api}
    end
  end

  def all_quoted_in(markets, currency), do: Enum.filter(markets, &(is_quoted_in?(&1, currency)))
  def all_based_on(markets, currency), do: Enum.filter(markets, &(is_based_on?(&1, currency)))

  defp is_based_on?(market, currency), do: market.base_currency == String.upcase(currency)
  defp is_quoted_in?(market, currency), do: market.quote_currency == String.upcase(currency)
  defp map_field({src_key, dst_key}, market), do: {dst_key, market[src_key]}
end
