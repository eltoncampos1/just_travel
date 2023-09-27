defmodule JustTravelWeb.Middlewares.CartSession do
  import Phoenix.LiveView, only: [get_connect_params: 1, push_event: 3]
  import Phoenix.Component
  alias JustTravel.Schemas.Cart

  alias JustTravel.Server.Cart, as: CartServer

  def on_mount(_, _params, _session, socket) do
    cart_id = get_connect_params(socket)["cart_id"]

    socket =
      socket
      |> create_cart(cart_id)

    {:cont, socket}
  end

  defp create_cart(socket, nil) do
    cart_id = Ecto.UUID.generate()

    socket
    |> build_cart(cart_id)
    |> assign_cart(cart_id)
  end

  defp create_cart(socket, cart_id) do
    case CartServer.get(cart_id) do
      :not_found ->
        socket
        |> build_cart(cart_id)
        |> assign_cart(cart_id)

      %Cart{} = cart ->
        socket
        |> assign_cart(cart)
    end
  end

  defp assign_cart(socket, %Cart{} = cart) do
    socket
    |> assign(cart: cart)
    |> push_event("create_cart_session_id", %{"cartId" => cart.id})
  end

  defp assign_cart(socket, cart_id) do
    socket
    |> assign(cart: %Cart{id: cart_id})
    |> push_event("create_cart_session_id", %{"cartId" => cart_id})
  end

  defp build_cart(socket, cart_id) do
    CartServer.create(cart_id)
    socket
  end
end
