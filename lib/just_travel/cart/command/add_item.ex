defmodule JustTravel.Cart.Command.AddItem do
  use JustTravel.EmbeddedSchema

  @required [:cart_id, :item]

  embedded_schema do
    field :cart_id, :binary_id
    field :item, :map
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
