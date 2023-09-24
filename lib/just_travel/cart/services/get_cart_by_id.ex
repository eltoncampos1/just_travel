defmodule JustTravel.Cart.Services.GetCartById do
  alias JustTravel.Cart.Command
  alias JustTravel.Schemas.Cart

  @spec execute(Commands.GetCartById.t()) :: {:ok, Cart.t()} | {:error, :not_found}
  def execute(%Commands.GetCartById{} = get_cart), do: Cart.Repository.find_cart(get_cart.cart_id)
end
