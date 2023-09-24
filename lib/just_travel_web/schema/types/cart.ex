defmodule JustTravelWeb.Schema.Types.Cart do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  object :cart do
    field :id, :id
    field :total_price, :price
    field :total_qty, :integer
    field :items, list_of(:item)
  end

  object :item do
    field :qty, :integer
    field :item, :ticket
  end

  input_object :create_cart_input do
    field :cart_id, non_null(:id)
  end

  object :price do
    field :amount, :integer
    field :currency, :string
  end


  payload_object(:cart_payload, :cart)
end
