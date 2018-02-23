defmodule ExBinance.Market do
  def build_series([head | rest]) do
    [build_single(head) | build_series(rest)]
  end

  def build_series([]) do
    []
  end

  def build_single(market) do
    %{base_currency: market["baseAsset"], quote_currency: market["quoteAsset"], status: market["status"]}
  end
end
