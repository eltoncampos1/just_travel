defmodule JustTravel.Ticket.Cart.Services.CreateCartTest do
  use JustTravel.DataCase, async: true
  alias JustTravel.Cart
  alias JustTravel.Schemas

  setup do
    params = %Cart.Command.CreateCart{
      cart_id: Ecto.UUID.generate()
    }

    %{params: params}
  end

  describe "execute/1" do
    test "should creates cart", %{params: params} do
      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: cart_id,
                items: [],
                total_price: %Money{amount: 0, currency: :BRL},
                total_qty: 0
              }} = Cart.Services.CreateCart.execute(params)

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: ^cart_id,
                items: [],
                total_price: %Money{amount: 0, currency: :BRL},
                total_qty: 0
              }} = Schemas.Cart.Repository.find_cart(cart_id)
    end
  end
end
