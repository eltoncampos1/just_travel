defmodule JustTravelWeb.Schema.Resolvers.Ticket do
  alias JustTravel.Ticket.Commands
  alias JustTravel.Cart.Commands, as: CartCommands
  alias JustTravel.Cart.Services, as: CartServices
  alias JustTravel.Ticket.Services
  alias JustTravel.Utils

  def list(%{filters: filters}, _ctx) do
    with {:ok, %Commands.ListByFilters{} = list_command} <-
           Utils.Changesets.cast_and_apply(Commands.ListByFilters, filters),
         {:ok, %{tickets: tickets}} when is_list(tickets) <- Services.ListByFilters.execute(list_command) do
      {:ok, tickets}
    end
  end

  def add_to_cart(%{cart_id: cart_id, ticket_id: ticket_id}, _ctx),
    do: Services.AddToCart.execute(cart_id, ticket_id)

  def remove(params, _ctx) do
    with {:ok, %CartCommands.RemoveCartItem{} = remove_ticket} <-
           Utils.Changesets.cast_and_apply(CartCommands.RemoveCartItem, params),
         {:ok, cart} <- CartServices.RemoveCartItem.execute(remove_ticket) do
      {:ok, cart}
    end
  end
end
