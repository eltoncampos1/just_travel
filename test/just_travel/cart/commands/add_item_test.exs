defmodule JustTravel.Cart.Commands.AddItemTest do
  use JustTravel.DataCase, async: true

  alias JustTravel.Cart

  setup do
    params = %{
      cart_id: Ecto.UUID.generate(),
      item: %{}
    }

    %{params: params}
  end

  describe "changeset/2" do
    test "returns a valid changeset", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = Cart.Commands.AddItem.changeset(params)
    end

    test "returns error on invalid input" do
      assert %Ecto.Changeset{
               valid?: false,
               errors: [
                 cart_id: {"is invalid", [type: :binary_id, validation: :cast]},
                 item: {"is invalid", [type: :map, validation: :cast]}
               ]
             } = Cart.Commands.AddItem.changeset(%{cart_id: 123, item: "invalid"})
    end

    for field <- [:cart_id, :item] do
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
