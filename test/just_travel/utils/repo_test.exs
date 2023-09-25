defmodule JustTravel.Utils.RepoTest do
  use JustTravel.DataCase, async: true
  alias JustTravel.Schemas.Cart.Repository
  alias JustTravel.Schemas.Ticket.Repository

  describe "paginate/2" do
    test "should paginate" do
      loc = insert(:location)
      per_page = 4
      insert_list(100, :ticket, location: loc)

      assert length(Repository.list()) == 100
      assert length(Repository.list(%{paginate: %{page: 1, per_page: per_page}})) == per_page
    end

    test "should paginate if no page was sent" do
      loc = insert(:location)
      per_page = 4
      insert_list(100, :ticket, location: loc)

      assert length(Repository.list()) == 100
      assert length(Repository.list(%{paginate: %{per_page: per_page}})) == per_page
    end
  end
end
