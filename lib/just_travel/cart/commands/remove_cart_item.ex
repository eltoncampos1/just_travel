defmodule JustTravel.Cart.Commands.RemoveCartItem do
  use JustTravel.EmbeddedSchema

  @required [:cart_id, :item_id, :action]

  embedded_schema do
    field :cart_id, :binary_id
    field :item_id, :binary_id
    field :action, Ecto.Enum, values: [:delete, :decrease]
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_uuid(:item_id)
    |> validate_uuid(:cart_id)
  end

  defp validate_uuid(changeset, field) do
    case get_field(changeset, field) do
      nil -> add_error(changeset, field, "`#{field} is Required`")
      value  -> validate(changeset, field, value)
    end
  end

  defp validate(changeset, key, id) do
    case Ecto.UUID.cast(id) do
      :error -> add_error(changeset, key, "Invalid type")
      {:ok, _id} -> changeset
    end
  end
end
