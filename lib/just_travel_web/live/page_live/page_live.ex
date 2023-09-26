defmodule JustTravelWeb.PageLive do
  use JustTravelWeb, :live_view

  alias JustTravelWeb.PageLive.Components
  alias JustTravel.Schemas.Ticket.Repository

  def mount(_params, _session, socket) do
    tickets = Repository.list()

    socket =
      socket
      |> assign(:location, "")
      |> assign(:tickets, tickets)

    {:ok, socket}
  end

  def handle_event("filter_by_location", %{"location" => location}, socket) do
    tickets = Repository.list(%{location_name: location})

    socket =
      socket
      |> assign(:location, location)
      |> assign(:tickets, tickets)

    {:noreply, socket}
  end
end
