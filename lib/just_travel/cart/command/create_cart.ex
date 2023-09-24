defmodule JustTravel.Cart.Command.CreateCart do
  use JustTravel.EmbeddedSchema

  @required [:cart_id]

  embedded_schema do
    field :cart_id, :binary_id
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
