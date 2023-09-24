defmodule JustTravelWeb.Schema.Types.Commom do
  use Absinthe.Schema.Notation

  object :price do
    field :amount, :integer
    field :currency, :string
  end
end
