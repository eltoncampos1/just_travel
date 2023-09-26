defmodule JustTravel.Utils.RepoTest do
  use JustTravel.DataCase, async: true
  alias JustTravel.Schemas.Cart.Repository
  alias JustTravel.Schemas.Ticket.Repository

  describe "paginate/2" do
    test "should paginate" do
      loc = insert(:location)
      per_page = 4

      for _i <- 1..10 do
        t = insert(:ticket, location: loc)
        insert(:ticket_price, ticket: t)
      end

      assert length(Repository.list()) == 10
      {:ok, %{tickets: t}} = Repository.list(%{paginate: %{page: 1, per_page: per_page}})
      assert length(t) == per_page
    end

    test "should paginate if no page was sent" do
      loc = insert(:location)
      per_page = 4

      for _i <- 1..10 do
        t = insert(:ticket, location: loc)
        insert(:ticket_price, ticket: t)
      end

      assert length(Repository.list()) == 10

      {:ok, %{tickets: t}} = Repository.list(%{paginate: %{per_page: per_page}})
      assert length(t) == per_page
    end
  end
end
