defmodule JustTravelWeb.Schema.Mutations.TicketTest do
  use JustTravelWeb.ConnCase

  @add_ticket_to_cart_mutation """
  mutation addTicketToCart($cartId: ID!, $ticketId: ID!) {
    addTicketToCart(cartId: $cartId, ticketId: $ticketId) {
    result {
      id
      totalPrice {
        amount
        currency
      }
      totalQty
      items {
        item {
          category
          country
          date
          description
          discount {
            amount
            currency
          }
          id
          location
          price {
            amount
            currency
          }

        }
      }
    }
      successful
    }
  }
  """

  describe "add_ticket_to_cart mutation" do
    setup [:setup_ticket]

    test "should add ticket to cart", %{conn: conn, ticket: ticket} do
      cart_id = Ecto.UUID.generate()
      tkt_id = ticket.id

      conn =
        post(conn, "/api/graphql", %{
          "query" => @add_ticket_to_cart_mutation,
          "variables" => %{
            "cartId" => cart_id,
            "ticketId" => tkt_id
          }
        })

      assert %{
               "data" => %{
                 "addTicketToCart" => %{
                   "result" => %{
                     "id" => ^cart_id,
                     "items" => [
                       %{
                         "item" => %{
                           "category" => "CHILDREN",
                           "country" => "USA",
                           "date" => _,
                           "description" => "Lorem ipsum silor dolor amet",
                           "discount" => %{"amount" => 500, "currency" => "BRL"},
                           "id" => ^tkt_id,
                           "location" => "Disney",
                           "price" => %{"amount" => 2000, "currency" => "BRL"}
                         }
                       }
                     ],
                     "totalPrice" => %{"amount" => 1500, "currency" => "BRL"},
                     "totalQty" => 1
                   },
                   "successful" => true
                 }
               }
             } = json_response(conn, 200)
    end
  end

  def setup_ticket(_) do
    ticket = insert(:ticket)
    insert(:ticket_discount, ticket: ticket)
    insert(:ticket_price, ticket: ticket)

    %{ticket: ticket}
  end
end
