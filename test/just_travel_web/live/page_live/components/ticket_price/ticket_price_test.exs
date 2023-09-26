defmodule JustTravelWeb.PageLive.Components.TicketPriceTest do
  use JustTravelWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "ticket price component" do
    test "render with discount", %{conn: conn} do
      loc = insert(:location, name: "TOKYO", country: "JAPAN")
      ticket = insert(:ticket, location: loc)
      price = insert(:ticket_price, ticket: ticket)
      disc = insert(:ticket_discount, ticket: ticket)

      {:ok, view, _html} = live(conn, "/")

      total_price = Money.subtract(price.price, disc.discount_amount)

      el = "[data-role=TICKET_PRICE]"
      total_price_el = "[data-role=TOTAL_PRICE]"
      assert has_element?(view, el)
      assert has_element?(view, total_price_el)
      assert element(view, total_price_el, total_price)
    end

    test "render without discount", %{conn: conn} do
      loc = insert(:location, name: "TOKYO", country: "JAPAN")
      ticket = insert(:ticket, location: loc)
      price = insert(:ticket_price, ticket: ticket)

      {:ok, view, _html} = live(conn, "/")


      el = "[data-role=TICKET_PRICE]"
      total_price_el = "[data-role=TOTAL_PRICE]"
      assert has_element?(view, el)
      assert has_element?(view, total_price_el)
      assert element(view, total_price_el, price.price)
    end
  end
end
