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
      messages {
      code
      field
      message
    }
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
                           "category" => _,
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

    test "return error with invalid UUID", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @add_ticket_to_cart_mutation,
          "variables" => %{
            "cartId" => 123,
            "ticketId" => 13313
          }
        })

      assert %{
               "data" => %{
                 "addTicketToCart" => %{
                   "messages" => [
                     %{"code" => "unknown", "field" => nil, "message" => "invalid_id_type"}
                   ],
                   "result" => nil,
                   "successful" => false
                 }
               }
             } = json_response(conn, 200)
    end

    test "return if ticket does not exists", %{conn: conn} do
      cart_id = Ecto.UUID.generate()

      conn =
        post(conn, "/api/graphql", %{
          "query" => @add_ticket_to_cart_mutation,
          "variables" => %{
            "cartId" => cart_id,
            "ticketId" => Ecto.UUID.generate()
          }
        })

      assert %{
               "data" => %{
                 "addTicketToCart" => %{
                   "messages" => [
                     %{"code" => "unknown", "field" => nil, "message" => "not_found"}
                   ],
                   "result" => nil,
                   "successful" => false
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
