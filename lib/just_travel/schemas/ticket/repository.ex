defmodule JustTravel.Schemas.Ticket.Repository do
  alias JustTravel.Repo
  alias JustTravel.Schemas

  import Ecto.Query

  @spec list_tickets_by_location_name(location_name :: String.t()) ::
          list(Schemas.Ticket.t()) | []
  def list_tickets_by_location_name(location_name) do
    from(tkt in Schemas.Ticket, as: :ticket)
    |> join(:left, [ticket: tkt], loc in Schemas.Location,
      as: :location,
      on: loc.id == tkt.location_id
    )
    |> Schemas.Location.Query.by_location_name(location_name)
    |> select([ticket: tkt], tkt)
    |> Repo.all()
  end
end
