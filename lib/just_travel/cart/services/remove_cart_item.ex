defmodule JustTravel.Cart.Services.RemoveCartItem do
  alias JustTravel.Cart
  alias JustTravel.Schemas

  @spec execute(Cart.Commands.RemoveCartItem.t()) :: term()
  def execute(%Cart.Commands.RemoveCartItem{} = remove_cart) do
    Schemas.Cart.Repository.remove_item(
      remove_cart.cart_id,
      remove_cart.item_id,
      remove_cart.action
    )
  end
end
