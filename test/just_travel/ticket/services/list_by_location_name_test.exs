defmodule JustTravel.Ticket.Services.ListByLocationNameTest do
  use JustTravel.DataCase, async: true

  alias JustTravel.Ticket.Services

  setup do
    location = insert(:location, name: "Disney")
    times_to_insert = 4

    for i <- 1..times_to_insert do
      insert(:ticket, name: "Travel Disney" <> to_string(i), location: location)
    end

    %{location: location, times_to_insert: times_to_insert}
  end

  describe "execute/1" do
    test "should return tickets given location name", %{
      location: location,
      times_to_insert: times_to_insert
    } do
      assert {:ok, tickets} = Services.ListByLocationName.execute(location.name)
      assert length(tickets) == times_to_insert

      assert Enum.all?(tickets, &(&1.location_id == location.id))
    end

    test "should return tickets given location name case insensitive", %{
      location: location,
      times_to_insert: times_to_insert
    } do
      assert {:ok, tickets} = Services.ListByLocationName.execute("disney")
      assert length(tickets) == times_to_insert

      assert Enum.all?(tickets, &(&1.location_id == location.id))
    end

    test "should return error given invalid inputs" do
      assert {:error, :not_found} = Services.ListByLocationName.execute("")
      assert {:error, :not_found} = Services.ListByLocationName.execute(nil)
      assert {:error, :not_found} = Services.ListByLocationName.execute("abracadabra")
    end
  end
end
