defmodule JustTravel.Cart.Services.CreateCart do
  alias JustTravel.Cart.Commands
  alias JustTravel.Schemas.Cart
  alias JustTravel.Schemas.Cart.Repository, as: CartRepository

  @spec execute(JustTravel.Cart.Commands.CreateCart.t()) :: :ok | {:ok, Cart.t()}
  def execute(%Commands.CreateCart{} = create_cart) do
    case CartRepository.find_cart(create_cart.cart_id) do
      {:error, :not_found} -> CartRepository.new(create_cart.cart_id)
      {:ok, cart} -> {:ok, cart}
    end
  end
end
