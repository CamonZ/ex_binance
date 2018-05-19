defmodule ExBinance.ApiClient do
  defmacro __using__(_) do
    quote do
      use Tesla

      plug(Tesla.Middleware.BaseUrl, "https://api.binance.com/api")
      plug(Tesla.Middleware.JSON)
    end
  end
end
