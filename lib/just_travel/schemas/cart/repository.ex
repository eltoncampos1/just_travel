defmodule JustTravel.Schemas.Cart.Repository do
  alias JustTravel.Schemas.Cart
  alias JustTravel.Server.Cart, as: CartServer

  @name CartServer.server_name()

  @spec new(cart_id :: binary()) :: JustTravel.Schemas.Cart.t()
  def new(cart_id) do
    cart = %Cart{id: cart_id}
    :ets.insert(@name, {cart_id, cart})
  end

  def find_cart(cart_id) do
    case :ets.lookup(@name, cart_id) do
      [] -> {:error, []}
      [{_cart_id, value}] -> {:ok, value}
    end
  end
end
