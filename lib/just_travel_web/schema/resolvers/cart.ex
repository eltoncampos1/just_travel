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
end
