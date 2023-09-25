defmodule JustTravel.Ticket.Cart.Services.RemoveCartItemTest do
  use JustTravel.DataCase, async: true
  alias JustTravel.Cart

  setup do
    ticket = insert(:ticket)
    insert(:ticket_discount, ticket: ticket)
    insert(:ticket_price, ticket: ticket)
    cart_id = Ecto.UUID.generate()
    JustTravel.Ticket.Services.AddToCart.execute(cart_id, ticket.id)
    JustTravel.Ticket.Services.AddToCart.execute(cart_id, ticket.id)
    JustTravel.Ticket.Services.AddToCart.execute(cart_id, ticket.id)

    delete = %Cart.Commands.RemoveCartItem{
      cart_id: cart_id,
      item_id: ticket.id,
      action: :delete
    }

    decrease = %Cart.Commands.RemoveCartItem{
      cart_id: cart_id,
      item_id: ticket.id,
      action: :decrease
    }

    %{delete_params: delete, decrease_params: decrease}
  end

  describe "execute/1" do
    test "should descrease item from cart", %{decrease_params: params} do
      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: cart_id,
                items: [
                  %{
                    item: %{
                      discount: %Money{amount: 500, currency: :BRL},
                      id: item_id,
                      location: "Disney",
                      price: %Money{amount: 2000, currency: :BRL}
                    },
                    qty: 2
                  }
                ],
                total_price: %Money{amount: 3000, currency: :BRL},
                total_qty: 2
              }} = Cart.Services.RemoveCartItem.execute(params)

      assert params.cart_id == cart_id
      assert params.item_id == item_id

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: cart_id,
                items: [
                  %{
                    item: %{
                      discount: %Money{amount: 500, currency: :BRL},
                      id: item_id,
                      location: "Disney",
                      price: %Money{amount: 2000, currency: :BRL}
                    },
                    qty: 1
                  }
                ],
                total_price: %Money{amount: 1500, currency: :BRL},
                total_qty: 1
              }} = Cart.Services.RemoveCartItem.execute(params)

      assert params.cart_id == cart_id
      assert params.item_id == item_id
    end

    test "should delete item from cart", %{delete_params: params} do
      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: cart_id,
                items: [],
                total_price: %Money{amount: 0, currency: :BRL},
                total_qty: 0
              }} = Cart.Services.RemoveCartItem.execute(params)

      assert params.cart_id == cart_id
    end
  end
end
