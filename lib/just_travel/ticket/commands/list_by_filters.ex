defmodule JustTravel.Ticket.Commands.ListByFilters do
  use JustTravel.EmbeddedSchema

  @required []
  @optional [:location_name, :id, :paginate]

  embedded_schema do
    field :location_name, :string
    field :id, :binary_id
    field :paginate, :map
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:location_name, min: 2)
    |> validate_metadata(:paginate, [:page, :per_page])
  end

  defp validate_metadata(changeset, field, required_keys) do
    case get_field(changeset, field) do
      ^field ->
        if Map.keys(field) == required_keys do
          changeset
        else
          add_error(
            changeset,
            field,
            "Metadata must be a map with keys #{inspect(required_keys)}"
          )
        end

      _ ->
        changeset
    end
  end
end
