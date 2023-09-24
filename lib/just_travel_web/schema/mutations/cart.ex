defmodule JustTravelWeb.Schema.Mutations.Cart do
  use Absinthe.Schema.Notation
  alias JustTravelWeb.Schema.Resolvers.Cart, as: CartResolver

  import AbsintheErrorPayload.Payload

  object :cart_mutations do
    @desc "Create cart mutation"
    field :create_cart, type: :cart_payload do
      resolve &CartResolver.create/2
      middleware &build_payload/2
    end
  end
end
