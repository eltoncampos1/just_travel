defmodule JustTravelWeb.PageLive.Components.ShopCartTest do
  use JustTravelWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "Shop cart component" do
    test "render", %{conn: conn} do
      loc = insert(:location, name: "TOKYO", country: "JAPAN")
      ticket = insert(:ticket, location: loc)
      insert(:ticket_price, ticket: ticket)

      {:ok, view, _html} = live(conn, "/")

      btn = "[data-role=CART_BUTTON]"
      el = "[data-role=SHOP_CART]"

      assert has_element?(view, btn)
      assert has_element?(view, el)
    end

    test "render empty cart", %{conn: conn} do
      loc = insert(:location, name: "TOKYO", country: "JAPAN")
      ticket = insert(:ticket, location: loc)
      insert(:ticket_price, ticket: ticket)
      {:ok, view, _html} = live(conn, "/")

      btn = "[data-role=CART_BUTTON]"
      el = "[data-role=SHOP_CART]"
      empty_cart = "[data-role=EMPTY_CART]"

      assert has_element?(view, btn)
      assert has_element?(view, el)
      assert has_element?(view, empty_cart)
    end

    test "render  cart", %{conn: conn} do
      loc = insert(:location, name: "TOKYO", country: "JAPAN")
      ticket = insert(:ticket, location: loc)
      insert(:ticket_price, ticket: ticket)
      cart_id = Ecto.UUID.generate()
      conn = conn |> put_connect_params(%{"cart_id" => cart_id})

      JustTravel.Ticket.Services.AddToCart.execute(cart_id, ticket.id)
      {:ok, view, _html} = live(conn, "/")

      btn = "[data-role=CART_BUTTON]"
      el = "[data-role=SHOP_CART]"
      empty_cart = "[data-role=EMPTY_CART]"
      item_cart = "[data-role=CART_ITEM]"
      assert has_element?(view, btn)
      assert has_element?(view, el)
      refute has_element?(view, empty_cart)
      assert has_element?(view, item_cart)
      assert element(view, item_cart <> "div>div>div>div>h5", ticket.name)
      assert element(view, item_cart <> "div>div>div>div>h5", Date.to_iso8601(ticket.date))
    end
  end
end
