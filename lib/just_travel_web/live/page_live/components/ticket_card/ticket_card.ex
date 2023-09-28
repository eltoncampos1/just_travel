defmodule JustTravelWeb.PageLive.Components.TicketCard do
  use JustTravelWeb, :live_component

  alias JustTravelWeb.PageLive.Components

  def path, do: "mock_#{:rand.uniform(4)}.png"
end
