defmodule JustTravel.Ticket.Cart.Services.AddItemTest do
  use JustTravel.DataCase, async: true
  alias JustTravel.Cart
  alias JustTravel.Schemas

  setup do
    params = %Cart.Commands.AddItem{
      cart_id: Ecto.UUID.generate(),
      item: %{
        price: Money.new(2000),
        id: Ecto.UUID.generate()
      }
    }

    %{params: params}
  end

  describe "execute/1" do
    test "should add item to cart", %{params: params} do
      assert {:ok,
              %Schemas.Cart{
                id:
                  {:ok,
                   %Schemas.Cart{
                     id: cart_id,
                     items: [],
                     total_price: %Money{amount: 0, currency: :BRL},
                     total_qty: 0
                   }},
                items: [
                  %{
                    item: %{
                      id: item_id,
                      price: %Money{amount: 2000, currency: :BRL}
                    },
                    qty: 1
                  }
                ],
                total_price: %Money{amount: 2000, currency: :BRL},
                total_qty: 1
              }} = Cart.Services.AddItem.execute(params)

      assert ^cart_id = params.cart_id
      assert ^item_id = params.item.id
    end
  end
end
