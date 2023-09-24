defmodule JustTravel.Cart.Services.AddItem do
  alias JustTravel.Cart.Command
  alias JustTravel.Schemas.Cart
  alias JustTravel.Schemas.Cart.Repository, as: CartRepository

  @spec execute(JustTravel.Cart.Command.AddItem.t()) :: {:error, :not_found} | {:ok, Cart.t()}
  def execute(%Command.AddItem{} = add_item) do
    case CartRepository.find_cart(add_item.cart_id) do
      {:error, :not_found} ->
        cart = CartRepository.new(add_item.cart_id)
        CartRepository.add_item(cart, add_item.item)

      {:ok, _} ->
        CartRepository.add_item(add_item.cart_id, add_item.item)
    end
  end
end
