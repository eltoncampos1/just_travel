defmodule JustTravel.Ticket.Services.AddToCart do
  alias JustTravel.Ticket
  alias JustTravel.Cart
  alias JustTravel.Schemas.Ticket.Repository, as: TicketRepository
  alias JustTravel.Utils

  @spec execute(cart_id :: binary(), ticket_id :: binary()) :: term
  def execute(cart_id, ticket_id) do
    with {:ok, ticket_id} <- cast_id(ticket_id),
         {:ok, ticket} <-
           TicketRepository.by_ticket_id(ticket_id, [:price, :discount, :location]),
         {:ok, %Ticket.Commands.AddToCart{} = add_to_cart} <- build_add_to_cart_command(ticket),
         item = Map.from_struct(add_to_cart),
         {:ok, %Cart.Commands.AddItem{} = add_item} <-
           Utils.Changesets.cast_and_apply(Cart.Commands.AddItem, %{cart_id: cart_id, item: item}) do
      Cart.Services.AddItem.execute(add_item)
    end
  end

  defp cast_id(id) do
    case Ecto.UUID.cast(id) do
      :error -> {:error, :invalid_id_type}
      id -> id
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
      name: ticket.name,
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
