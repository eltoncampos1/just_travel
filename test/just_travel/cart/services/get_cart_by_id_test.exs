defmodule JustTravel.Ticket.Cart.Services.GetCartByIdTest do
  use JustTravel.DataCase, async: true
  alias JustTravel.Cart
  alias JustTravel.Schemas

  setup do
    cart_id = Ecto.UUID.generate()
    Schemas.Cart.Repository.new(cart_id)

    params = %Cart.Commands.GetCartById{
      cart_id: cart_id
    }

    %{params: params}
  end

  describe "execute/1" do
    test "should get a cart", %{params: params} do
      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: cart_id,
                items: [],
                total_price: %Money{amount: 0, currency: :BRL},
                total_qty: 0
              }} = Cart.Services.GetCartById.execute(params)

      assert ^cart_id = params.cart_id
    end

    test "should return not_found" do
      params = %Cart.Commands.GetCartById{
        cart_id: Ecto.UUID.generate()
      }

      assert {:error, :not_found} = Cart.Services.GetCartById.execute(params)
    end
  end
end
