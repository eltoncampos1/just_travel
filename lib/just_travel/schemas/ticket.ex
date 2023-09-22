defmodule JustTravel.Schemas.Ticket do
  @moduledoc """
  Schema for a ticket
  """

  use JustTravel.Schema

  alias JustTravel.Schemas

  @required [:name, :date, :description]
  @optional []

  schema "tickets" do
    field :name, :string
    field :description, :string
    field :date, :date
    belongs_to :location, Schemas.Location

    has_many :prices, Schemas.TicketPrice
    has_one :discount, Schemas.TicketDiscount
    timestamps()
  end

  @spec changeset(schema :: __MODULE__.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:description, min: 10, max: 300)
    |> cast_assoc(:location)
  end
end
