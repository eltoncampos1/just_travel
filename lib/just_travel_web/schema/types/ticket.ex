defmodule JustTravelWeb.Schema.Types.Ticket do
  use Absinthe.Schema.Notation

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
  end
end
