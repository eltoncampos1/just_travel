defmodule JustTravel.Cart.Commands.RemoveCartitemTest do
  use JustTravel.DataCase, async: true

  alias JustTravel.Cart

  setup do
    params = %{
      cart_id: Ecto.UUID.generate(),
      item_id: Ecto.UUID.generate(),
      action: :decrease
    }

    %{params: params}
  end

  describe "changeset/2" do
    test "returns a valid changeset", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = Cart.Commands.RemoveCartItem.changeset(params)
    end

    for field <- [:cart_id, :item_id, :action] do
      test "returns error on missing `#{field}`", %{params: params} do
        assert %Ecto.Changeset{
                 valid?: false
               } =
                 params
                 |> Map.drop([unquote(field)])
                 |> Cart.Commands.AddItem.changeset()
      end
    end
  end
end
