defmodule JustTravel.Schemas.Ticket.RepositoryTest do
  use JustTravel.DataCase, async: true

  alias JustTravel.Schemas.Ticket.Repository
  alias JustTravel.Schemas

  setup do
    location = insert(:location, name: "Disney")
    times_to_insert = 4

    for i <- 1..times_to_insert do
      insert(:ticket, name: "Travel Disney" <> to_string(i), location: location)
    end

    insert(:ticket,
      name: "Travel Salvador",
      location: insert(:location, name: "Salvador", country: "Brasil")
    )

    %{location: location, times_to_insert: times_to_insert}
  end

  describe "list_tickets_by_location_name/1" do
    test "should return tickets given location name", %{
      location: location,
      times_to_insert: times_to_insert
    } do
      assert [%Schemas.Ticket{} | _tickets] =
               tickets = Repository.list_tickets_by_location_name(location.name)

      assert length(tickets) == times_to_insert

      assert Enum.all?(tickets, &(&1.location_id == location.id))
    end

    test "should return all tickets given empty or nil input", %{
      times_to_insert: times_to_insert
    } do
      assert [%Schemas.Ticket{} | _tickets] =
               tickets_empty = Repository.list_tickets_by_location_name("")

      assert [%Schemas.Ticket{} | _tickets] =
               tickets_nil = Repository.list_tickets_by_location_name(nil)

      assert length(tickets_empty) == times_to_insert + 1
      assert length(tickets_nil) == times_to_insert + 1
    end

    test "should return tickets given location name case insensitive", %{
      location: location,
      times_to_insert: times_to_insert
    } do
      assert [%Schemas.Ticket{} | _tickets] =
               tickets = Repository.list_tickets_by_location_name("disney")

      assert length(tickets) == times_to_insert

      assert Enum.all?(tickets, &(&1.location_id == location.id))
    end

    test "should return error given invalid locations" do
      assert [] = Repository.list_tickets_by_location_name("abracadabra")
    end
  end
end
