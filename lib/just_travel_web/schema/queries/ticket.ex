defmodule JustTravelWeb.Schema.Queries.Ticket do
  use Absinthe.Schema.Notation

  alias JustTravelWeb.Schema.Resolvers.Ticket, as: TicketResolver

  object :tickets do
    @desc "Query for tickets"
    field :tickets, list_of(:ticket) do
      arg :filters, :ticket_filters_input

      resolve &TicketResolver.list/2
    end
  end
end
