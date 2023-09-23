defmodule JustTravelWeb.Schema.Resolvers.Ticket do
  alias JustTravel.Ticket.Commands
  alias JustTravel.Ticket.Services
  alias JustTravel.Utils

  def list(%{filters: filters}, _ctx) do
    with {:ok, %Commands.ListByFilters{} = list_command} <-
           Utils.Changesets.cast_and_apply(Commands.ListByFilters, filters),
         tickets when is_list(tickets) <- Services.ListByFilters.execute(list_command) do
      {:ok, tickets}
    end
  end
end
