defmodule JustTravelWeb.Schema.Resolvers.Cart do
  alias JustTravel.Utils
  alias JustTravel.Cart
  alias JustTravel.Schemas

  def create(_, _ctx) do
    cart_id = Ecto.UUID.generate()

    with {:ok, %Cart.Command.CreateCart{} = create_command} <-
           Utils.Changesets.cast_and_apply(Cart.Command.CreateCart, %{cart_id: cart_id}),
         {:ok, %Schemas.Cart{} = cart} <- Cart.Services.CreateCart.execute(create_command) do
      {:ok, cart}
    end
  end

  def get_by_id(%{cart_id: cart_id} = params, _ctx) when not is_nil(cart_id) do
    with {:ok, %Cart.Command.GetCartById{} = get_cart} <-
           Utils.Changesets.cast_and_apply(Cart.Command.GetCartById, params),
         {:ok, %Schemas.Cart{} = cart} <- Cart.Services.GetCartById.execute(get_cart) do
      {:ok, cart}
    end
  end
end
