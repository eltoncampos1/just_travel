defmodule JustTravel.Ticket.Commands.AddToCartTest do
  use JustTravel.DataCase, async: true
  alias JustTravel.Ticket

  setup do
    ticket = insert(:ticket)
    discount = insert(:ticket_discount, ticket: ticket)
    price = insert(:ticket_price, ticket: ticket)

    params = %{
      id: ticket.id,
      price: price.price,
      description: ticket.description,
      date: ticket.date,
      category: price.category,
      location: ticket.location.name,
      country: ticket.location.country,
      discount: discount.discount_amount
    }

    %{params: params}
  end

  describe "changeset/2" do
    test "returns a valid changeset", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = Ticket.Commands.AddToCart.changeset(params)
    end

    for field <- [:id, :price, :description, :date, :category, :location, :country] do
      test "returns error on missing `#{field}`", %{params: params} do
        assert %Ecto.Changeset{
                 valid?: false
               } =
                 params
                 |> Map.drop([unquote(field)])
                 |> Ticket.Commands.AddToCart.changeset()
      end
    end
  end
end
