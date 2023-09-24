defmodule JustTravel.Cart.Commands.CreateCartTest do
  use JustTravel.DataCase, async: true
  alias JustTravel.Cart

  setup do
    params = %{
      cart_id: Ecto.UUID.generate()
    }

    %{params: params}
  end

  describe "changeset/2" do
    test "returns a valid changeset", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = Cart.Commands.CreateCart.changeset(params)
    end

    test "returns error on invalid input" do
      assert %Ecto.Changeset{
               valid?: false,
               errors: [cart_id: {"is invalid", [type: :binary_id, validation: :cast]}]
             } = Cart.Commands.CreateCart.changeset(%{cart_id: 123})
    end

    test "returns error on missing required params" do
      assert %Ecto.Changeset{
               valid?: false,
               errors: [cart_id: {"can't be blank", [validation: :required]}]
             } = Cart.Commands.CreateCart.changeset(%{id: 123})
    end
  end
end
