defmodule JustTravel.Cart.Services.CreateCart do
  alias JustTravel.Cart.Command
  alias JustTravel.Server.Cart, as: CartServer

  def execute(%Command.CreateCart{} = create_cart), do: CartServer.create(create_cart.cart_id)
end
