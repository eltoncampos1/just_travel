defmodule JustTravelWeb.Schema.Types.Ticket do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  object :ticket do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :date, :date
    field :location, :location
    field :location_id, :id
    field :insertd_at, :datetime
    field :updated_at, :datetime
  end

  input_object :ticket_filters_input do
    field :location_name, :string
    field :id, :id
    field :paginate, :paginate
  end

  input_object :paginate do
    field :page, :integer
    field :per_page, :integer
  end

  enum :category, values: [:adult, :children]

  object :ticket_cart do
    field :id, :id
    field :total_price, :price
    field :total_qty, :integer
    field :items, list_of(:t_item)
  end

  object :t_item do
    field :item, :ticket_item
    field :qty, :integer
  end

  object :ticket_item do
    field :id, :id
    field :price, :price
    field :description, :string
    field :location, :string
    field :category, :category
    field :country, :string
    field :date, :date
    field :discount, :price
  end

  payload_object(:ticket_cart_payload, :ticket_cart)
end
