defmodule JustTravelWeb.Schema.Queries.TicketTest do
  use JustTravelWeb.ConnCase

  @ticket_query """
  query tickets($filters: TicketFiltersInput) {
    tickets(filters: $filters) {
      id
      name
      date
      locationId
    }
  }
  """

  setup do
    location = insert(:location, name: "Disney")

    for i <- 1..2 do
      insert(:ticket, name: "Travel Disney" <> to_string(i), location: location)
    end

    location_2 = insert(:location, name: "Paris", country: "France")

    for i <- 1..2 do
      insert(:ticket, name: "Travel Paris" <> to_string(i), location: location_2)
    end

    %{location_1: location, location_2: location_2}
  end

  describe "tickets query" do
    test "return tickets by location name", %{conn: conn, location_1: location} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @ticket_query,
          "variables" => %{
            filters: %{
              location_name: location.name
            }
          }
        })

      assert %{
               "data" => %{
                 "tickets" => [
                   %{
                     "date" => _,
                     "id" => _,
                     "locationId" => location_id_1,
                     "name" => _
                   },
                   %{
                     "date" => _,
                     "id" => _,
                     "locationId" => location_id_2,
                     "name" => _
                   }
                 ]
               }
             } = json_response(conn, 200)

      assert Enum.all?([location_id_1, location_id_2], &(&1 == location.id))
    end

    test "return error if has invalid location name filter - [invalid location]", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @ticket_query,
          "variables" => %{
            filters: %{
              location_name: "invalid"
            }
          }
        })

      assert %{"data" => %{"tickets" => []}} = json_response(conn, 200)
    end

    test "return all tickets location name filter - [empty string]", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @ticket_query,
          "variables" => %{
            filters: %{
              location_name: ""
            }
          }
        })

      assert %{
               "data" => %{
                 "tickets" => tickets
               }
             } = json_response(conn, 200)

      assert length(tickets) == 4
    end

    test "returns ticket by id", %{conn: conn} do
      ticket = insert(:ticket, name: "Travel to Rome")

      conn =
        post(conn, "/api/graphql", %{
          "query" => @ticket_query,
          "variables" => %{
            filters: %{
              id: ticket.id
            }
          }
        })

      assert %{
               "data" => %{
                 "tickets" => [
                   %{
                     "date" => date,
                     "id" => id,
                     "locationId" => location_id,
                     "name" => name
                   }
                 ]
               }
             } = json_response(conn, 200)

      assert %{id: ^id, name: ^name, location_id: ^location_id} = ticket
      assert Date.to_iso8601(ticket.date) == date
    end

    test "return [] if no ticket is founded by id", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @ticket_query,
          "variables" => %{
            filters: %{
              id: Ecto.UUID.generate()
            }
          }
        })

      assert %{"data" => %{"tickets" => []}} = json_response(conn, 200)
    end
  end
end
