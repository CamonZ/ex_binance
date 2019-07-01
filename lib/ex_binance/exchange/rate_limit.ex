defmodule ExBinance.Exchange.RateLimit do
  defstruct type: nil, interval: nil, limit: nil

  @types_to_atom %{"REQUEST_WEIGHT" => :request_weight, "ORDERS" => :orders, "RAW_REQUESTS" => :raw_requests}
  @intervals_to_atom %{"MINUTE" => :minute, "SECOND" => :second, "DAY" => :day}

  alias __MODULE__

  def new(limits) when is_list(limits) do
    Enum.map(limits, &new/1)
  end

  def new(%{"rateLimitType" => type, "interval" => interval, "limit" => limit}) do
    %RateLimit{
      type: @types_to_atom[type],
      interval: @intervals_to_atom[interval],
      limit: limit
    }
  end
end
