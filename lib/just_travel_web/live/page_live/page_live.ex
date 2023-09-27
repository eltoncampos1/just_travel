defmodule JustTravelWeb.PageLive do
  use JustTravelWeb, :live_view

  alias JustTravel.Schemas.Ticket.Repository
  alias JustTravel.Ticket.Services.AddToCart
  alias JustTravelWeb.PageLive.Components
  alias JustTravelWeb.Core
  alias JustTravel.Schemas.Cart.Repository, as: CartRepository
  alias JustTravel.Server.Cart, as: CartServer

  def handle_params(params, _uri, socket) do
    cart = socket.assigns.cart
    if connected?(socket), do: CartRepository.subscribe_pubsub(cart.id)

    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "4")
    location = Map.get(socket.assigns, :location, "")
    options = %{page: page, per_page: per_page}

    {tickets, total} = get_tickets(location, options)

    max_pages = div(total, per_page) |> round()

    assigns = [
      options: options,
      tickets: tickets,
      total: total,
      location: location,
      max_pages: max_pages,
      cart: cart
    ]

    socket = assign(socket, assigns)

    {:noreply, socket}
  end

  def handle_event("filter_by_location", %{"location" => location}, socket) do
    options = socket.assigns.options

    {tickets, total} = get_tickets(location, options)

    assigns = [location: location, tickets: tickets, total: total]

    socket =
      socket
      |> assign(:assigns, socket.assigns)
      |> assign(assigns)

    {:noreply, socket}
  end

  def handle_event("select_page", %{"page" => page}, socket) do
    page = String.to_integer(page)
    options = socket.assigns.options |> Map.put(:page, page)

    {tickets, total} = get_tickets(socket.assigns.location, options)
    assigns = [tickets: tickets, total: total]

    socket =
      socket
      |> assign(:assigns, socket.assigns)
      |> assign(options: options)
      |> assign(assigns)
      |> push_patch(to: "/?page=#{page}&per_page=#{options.per_page}")

    {:noreply, socket}
  end

  def handle_event("add_to_cart", %{"id" => ticket_id}, socket) do
    cart_id = socket.assigns.cart.id

    cart_id
    |> AddToCart.execute(ticket_id)

    socket =
      socket
      |> put_flash(:info, "Ticket adicionado ao carrinho.")

    {:noreply, socket}
  end

  def handle_event("remove_from_cart", %{"id" => ticket_id}, socket) do
    cart_id = socket.assigns.cart.id

    CartServer.delete(cart_id, ticket_id)

    {:noreply, socket}
  end

  def handle_info({:new_item, cart_id}, socket) do
    cart = CartServer.get(cart_id)

    {:noreply, assign(socket, cart: cart)}
  end

  def handle_info({:delete_error, _cart_id}, socket) do
    {:noreply, put_flash(socket, :error, "Erro ao deleter ticket")}
  end

  def handle_info({:delete_success, cart_id}, socket) do
    send(self(), {:new_item, cart_id})
    {:noreply, put_flash(socket, :info, "Ticket deletado com sucesso!")}
  end

  defp get_tickets(location, options) do
    {:ok, %{tickets: tickets, total: total}} =
      Repository.list(%{location_name: location, paginate: options})

    {tickets, total}
  end
end
