defmodule JustTravel.Cart.Services.GetCartById do
  alias JustTravel.Cart.Command
  alias JustTravel.Schemas.Cart

  @spec execute(Command.GetCartById.t()) :: {:ok, Cart.t()} | {:error, :not_found}
  def execute(%Command.GetCartById{} = get_cart), do: Cart.Repository.find_cart(get_cart.cart_id)
end
