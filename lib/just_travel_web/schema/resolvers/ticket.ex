defmodule JustTravelWeb.Schema.Resolvers.Ticket do
  alias JustTravel.Ticket

  def list(%{filters: filters}, _ctx),
    do: Ticket.Services.ListByLocationName.execute(filters.location_name)
end
