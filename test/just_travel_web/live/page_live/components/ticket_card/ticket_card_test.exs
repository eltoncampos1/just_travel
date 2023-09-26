defmodule JustTravelWeb.PageLive.Components.TicketCardTest do
  use JustTravelWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "ticket price component" do
    test "render", %{conn: conn} do
      loc = insert(:location, name: "TOKYO", country: "JAPAN")
      ticket = insert(:ticket, location: loc)
      insert(:ticket_price, ticket: ticket)

      {:ok, view, _html} = live(conn, "/")

      price_el = "[data-role=TICKET_PRICE]"
      el = "[data-role=TICKET_CARD]"

      name = "#{ticket.name} - #{loc.name}"
      assert has_element?(view, el)
      assert has_element?(view, price_el)
      assert element(view, el <> "div>div>div>div>p", name)
      assert element(view, el <> "div>div>div>h3", ticket.name)
    end
  end
end
