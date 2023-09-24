defmodule JustTravel.Ticket.Commands.AddToCartTest do
  use JustTravel.DataCase, async: true
  alias JustTravel.Ticket

  setup do
    ticket = insert(:ticket)
    discount = insert(:ticket_discount, ticket: ticket)
    price = insert(:ticket_price, ticket: ticket)
    params =  %{
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
      assert "" = Ticket.Commands.AddToCart.changeset(params)
    end

    # test "returns error on invalid input" do
    #   assert %Ecto.Changeset{
    #            valid?: false,
    #            errors: [
    #              cart_id: {"is invalid", [type: :binary_id, validation: :cast]},
    #              item: {"is invalid", [type: :map, validation: :cast]}
    #            ]
    #          } = Cart.Commands.AddItem.changeset(%{cart_id: 123, item: "invalid"})
    # end

    # for field <- [:cart_id, :item] do
    #   test "returns error on missing `#{field}`", %{params: params} do
    #     assert %Ecto.Changeset{
    #              valid?: false
    #            } =
    #              params
    #              |> Map.drop([unquote(field)])
    #              |> Cart.Commands.AddItem.changeset()
    #   end
    # end
  end
end
