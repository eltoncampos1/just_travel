defmodule JustTravelWeb.Schema.Queries.Cart do
  use Absinthe.Schema.Notation

  alias JustTravelWeb.Schema.Resolvers.Cart, as: CartResolver

  alias Crudry.Middlewares.TranslateErrors

  object :cart_queries do
    @desc "Query for carts"
    field :cart_by_id, :cart do
      arg :cart_id, non_null(:id)

      resolve &CartResolver.get_by_id/2
      middleware TranslateErrors
    end
  end
end
