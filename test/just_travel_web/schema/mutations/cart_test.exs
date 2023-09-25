defmodule JustTravelWeb.Schema.Mutations.CartTest do
  use JustTravelWeb.ConnCase

  @remove_from_cart_mutation """
      mutation removeFromCart($cartId: ID!, $itemId: ID!, $action: Actions) {
        removeTicketFromCart(cartId: $cartId, itemId: $itemId, action: $action) {
          messages {
            code
            field
          }
          successful
          result {
            id
            totalQty
            totalPrice {
              amount
              currency
            }
            items {
              qty
              item {
                category
                country
                date
                description
                id
                location
                price {
                  amount
                  currency
                }
                discount {
                  amount
                  currency
                }

              }
            }
          }
        }
      }
  """

  describe "remove items from cart" do
    setup [:setup_ticket]

    test "should decrease", %{conn: conn, ticket_id: tkt, cart_id: ct} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @remove_from_cart_mutation,
          "variables" => %{
            "cartId" => ct,
            "itemId" => tkt,
            "action" => "DECREASE"
          }
        })

      assert %{
               "data" => %{
                 "removeTicketFromCart" => %{
                   "messages" => [],
                   "result" => %{
                     "id" => _,
                     "items" => [
                       %{
                         "item" => %{
                           "discount" => %{"amount" => 500, "currency" => "BRL"},
                           "id" => _,
                           "price" => %{"amount" => 2000, "currency" => "BRL"}
                         },
                         "qty" => 2
                       }
                     ],
                     "totalPrice" => %{"amount" => 3000, "currency" => "BRL"},
                     "totalQty" => 2
                   },
                   "successful" => true
                 }
               }
             } = json_response(conn, 200)

      conn =
        post(conn, "/api/graphql", %{
          "query" => @remove_from_cart_mutation,
          "variables" => %{
            "cartId" => ct,
            "itemId" => tkt,
            "action" => "DECREASE"
          }
        })

      assert %{
               "data" => %{
                 "removeTicketFromCart" => %{
                   "messages" => [],
                   "result" => %{
                     "items" => [
                       %{
                         "item" => %{
                           "discount" => %{"amount" => 500, "currency" => "BRL"},
                           "location" => "Disney",
                           "price" => %{"amount" => 2000, "currency" => "BRL"}
                         },
                         "qty" => 1
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

    test "should delete item from cart", %{conn: conn, ticket_id: tkt, cart_id: ct} do
      {:ok, cart} = JustTravel.Schemas.Cart.Repository.find_cart(ct)

      assert [%{qty: 3, item: %{id: ^tkt}}] = cart.items

      conn =
        post(conn, "/api/graphql", %{
          "query" => @remove_from_cart_mutation,
          "variables" => %{
            "cartId" => ct,
            "itemId" => tkt,
            "action" => "DELETE"
          }
        })

      assert %{
               "data" => %{
                 "removeTicketFromCart" => %{
                   "messages" => [],
                   "result" => %{
                     "id" => ^ct,
                     "items" => [],
                     "totalPrice" => %{"amount" => 0, "currency" => "BRL"},
                     "totalQty" => 0
                   },
                   "successful" => true
                 }
               }
             } = json_response(conn, 200)
    end
  end

  defp setup_ticket(_) do
    ticket = insert(:ticket)
    insert(:ticket_discount, ticket: ticket)
    insert(:ticket_price, ticket: ticket)
    cart_id = Ecto.UUID.generate()

    JustTravel.Ticket.Services.AddToCart.execute(cart_id, ticket.id)
    JustTravel.Ticket.Services.AddToCart.execute(cart_id, ticket.id)
    JustTravel.Ticket.Services.AddToCart.execute(cart_id, ticket.id)

    %{ticket_id: ticket.id, cart_id: cart_id}
  end
end
