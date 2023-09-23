defmodule JustTravel.Schemas.Ticket.Query do
  @moduledoc """
  Query module for Ticket
  """
  import Ecto.Query

  @spec by_ticket_id(queryable :: Ecto.Queryable.t(), location_name :: String.t()) ::
          Ecto.Queryable.t()
  def by_ticket_id(queryable, id) do
    where(queryable, [ticket: ticket], ticket.id == ^id)
  end
end
