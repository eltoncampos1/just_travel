defmodule JustTravel.Schemas.Cart do
  defstruct id: nil, items: [], total_price: Money.new(0), total_qty: 0
end
