defmodule JustTravel.Ticket.Services.AddToCartTest do
  use JustTravel.DataCase, async: true

  alias JustTravel.Ticket

  setup do
    ticket = insert(:ticket)
    insert(:ticket_discount, ticket: ticket)
    insert(:ticket_price, ticket: ticket)

    %{ticket: ticket}
  end

  describe "execute/2" do
    test "should add ticket to cart", %{ticket: tkt} do
      cart_id = Ecto.UUID.generate()
      item_id = tkt.id

      assert {:ok,
              %JustTravel.Schemas.Cart{
                id: ^cart_id,
                items: [
                  %{
                    item: %{
                      id: ^item_id
                    },
                    qty: 1
                  }
                ],
                total_price: %Money{amount: 1500, currency: :BRL},
                total_qty: 1
              }} = Ticket.Services.AddToCart.execute(cart_id, tkt.id)

    end
  end
end
