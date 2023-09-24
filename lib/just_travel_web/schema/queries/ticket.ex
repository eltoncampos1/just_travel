defmodule JustTravelWeb.Schema.Queries.Ticket do
  use Absinthe.Schema.Notation

  alias JustTravelWeb.Schema.Resolvers.Ticket, as: TicketResolver

  alias Crudry.Middlewares.TranslateErrors

  object :tickets_queries do
    @desc "Query for tickets"
    field :tickets, list_of(:ticket) do
      arg :filters, :ticket_filters_input

      resolve &TicketResolver.list/2
      middleware TranslateErrors
    end
  end
end
