defmodule JustTravelWeb.Schema.Mutations.Ticket do
  use Absinthe.Schema.Notation
  alias JustTravelWeb.Schema.Resolvers.Ticket, as: TicketResolver

  import AbsintheErrorPayload.Payload

  object :ticket_mutations do
    field :add_ticket_to_cart, type: :ticket_cart_payload do
      @desc "Create ticket cart mutation"
      arg :cart_id, non_null(:id)
      arg :ticket_id, non_null(:id)
      resolve &TicketResolver.add_to_cart/2
      middleware &build_payload/2
    end

    field :remove_ticket_from_cart, type: :ticket_cart_payload do
      @desc "Decrease ticket cart mutation"
      arg :cart_id, non_null(:id)
      arg :item_id, non_null(:id)
      arg :action, :actions
      resolve &TicketResolver.remove/2
      middleware &build_payload/2
    end
  end
end
