defmodule JustTravel.Schemas.TicketPrice do
  @moduledoc """
  Schema for a ticket price
  """

  use JustTravel.Schema
  alias JustTravel.Schemas

  @required [:category, :price, :ticket_id]
  @optional []
  @ticket_values [:children, :adult]

  schema "ticket_prices" do
    field :category, Ecto.Enum, values: @ticket_values
    field :price, Money.Ecto.Type

    belongs_to :ticket, Schemas.Ticket

    timestamps()
  end

  @spec changeset(schema :: __MODULE__.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> assoc_constraint(:ticket)
  end
end
