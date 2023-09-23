defmodule JustTravelWeb.Schema.Types.Location do
  use Absinthe.Schema.Notation

  object :location do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :country, non_null(:string)
    field :insertd_at, :datetime
    field :updated_at, :datetime
  end
end
