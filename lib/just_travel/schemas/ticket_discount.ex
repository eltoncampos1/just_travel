defmodule JustTravel.Schemas.TicketDiscount do
  @moduledoc """
  Schema for a ticket discount
  """

  use JustTravel.Schema
  alias JustTravel.Schemas

  @required [:ticket_id, :discount_amount, :discount_name]
  @optional []

  schema "ticket_discounts" do
    field :discount_name, :string
    field :discount_amount, Money.Ecto.Type
    belongs_to :ticket, Schemas.Ticket
    timestamps()
  end

  @spec changeset(schema :: __MODULE__.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:name, min: 2)
    |> validate_length(:description, min: 10)
    |> assoc_constraint(:ticket)
  end
end
