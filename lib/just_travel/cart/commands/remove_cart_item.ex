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
  end
end
