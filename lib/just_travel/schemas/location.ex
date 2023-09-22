defmodule JustTravel.Schemas.Location do
  @moduledoc """
  Schema for a Location
  """

  use JustTravel.Schema

  alias JustTravel.Schemas

  @required [:name, :country]
  @optional []

  schema "locations" do
    field :name, :string
    field :country, :string

    has_many :tickets, Schemas.Ticket
    timestamps()
  end

  @spec changeset(schema :: __MODULE__.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
