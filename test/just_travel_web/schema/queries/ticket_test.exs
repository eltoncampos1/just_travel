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

      assert %{
               "data" => %{"tickets" => nil},
               "errors" => [
                 %{
                   "locations" => _,
                   "message" => "not_found",
                   "path" => ["tickets"]
                 }
               ]
             } = json_response(conn, 200)
    end

    test "return error if has invalid location name filter - [empty string]", %{conn: conn} do
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
               "data" => %{"tickets" => nil},
               "errors" => [
                 %{
                   "locations" => _,
                   "message" => "not_found",
                   "path" => ["tickets"]
                 }
               ]
             } = json_response(conn, 200)
    end

    test "return error if has invalid location name filter - [nil]", %{conn: conn} do
      conn =
        post(conn, "/api/graphql", %{
          "query" => @ticket_query,
          "variables" => %{
            filters: %{
              location_name: nil
            }
          }
        })

      assert %{
               "data" => %{"tickets" => nil},
               "errors" => [
                 %{
                   "locations" => _,
                   "message" => "not_found",
                   "path" => ["tickets"]
                 }
               ]
             } = json_response(conn, 200)
    end
  end
end
