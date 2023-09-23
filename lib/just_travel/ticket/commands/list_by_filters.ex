defmodule JustTravel.Ticket.Commands.ListByFilters do
  use JustTravel.EmbeddedSchema

  @required []
  @optional [:location_name, :id]

  embedded_schema do
    field :location_name, :string
    field :id, :binary_id
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:location_name, min: 2)
  end
end
