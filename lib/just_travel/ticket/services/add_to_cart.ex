defmodule JustTravel.Ticket.Services.AddToCart do
  alias JustTravel.Ticket
  alias JustTravel.Schemas.Cart.Repository, as: CartRepository
  alias JustTravel.Schemas.Ticket.Repository, as: TicketRepository
  alias JustTravel.Utils

  @spec execute(cart_id :: binary(), ticket_id :: binary()) :: term
  def execute(cart_id, ticket_id) do
    with {:ok, ticket} <-
           TicketRepository.by_ticket_id(ticket_id, [:price, :discount, :location]),
         {:ok, %Ticket.Commands.AddToCart{} = add_to_cart} <- build_add_to_cart_command(ticket) do
      item = Map.from_struct(add_to_cart)
      CartRepository.add_item(cart_id, item)
    end
  end

  defp build_add_to_cart_command(%JustTravel.Schemas.Ticket{} = ticket) do
    params = build_params(ticket)

    case Utils.Changesets.cast_and_apply(Ticket.Commands.AddToCart, params) do
      {:ok, %Ticket.Commands.AddToCart{} = add_to_cart} -> {:ok, add_to_cart}
      error -> error
    end
  end

  defp build_params(%JustTravel.Schemas.Ticket{} = ticket) do
    %{
      id: ticket.id,
      price: ticket.price.price,
      description: ticket.description,
      date: ticket.date,
      category: ticket.price.category,
      location: ticket.location.name,
      country: ticket.location.country,
      discount: ticket.discount.discount_amount
    }
  end
end
