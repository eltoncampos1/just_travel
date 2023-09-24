defmodule JustTravel.Ticket.Commands.AddToCart do
  use JustTravel.EmbeddedSchema

  @required [:id, :price, :description, :location, :country, :category, :date]
  @optional [:discount]

  embedded_schema do
    field :id, :binary_id
    field :price, Money.Ecto.Type
    field :description, :string
    field :category, Ecto.Enum, values: [:adult, :children]
    field :location, :string
    field :country, :string
    field :date, :date
    field :discount, Money.Ecto.Type
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
