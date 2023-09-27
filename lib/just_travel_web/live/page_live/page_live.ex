defmodule JustTravelWeb.PageLive do
  use JustTravelWeb, :live_view

  alias JustTravel.Schemas.Ticket.Repository
  alias JustTravelWeb.PageLive.Components
  alias JustTravelWeb.Core

  def handle_params(params, _uri, socket) do
    cart = socket.assigns.cart
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

  defp get_tickets(location, options) do
    {:ok, %{tickets: tickets, total: total}} =
      Repository.list(%{location_name: location, paginate: options})

    {tickets, total}
  end
end
