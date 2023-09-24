defmodule JustTravelWeb.Schema.Mutations do
  use Absinthe.Schema.Notation
  alias JustTravelWeb.Schema.Mutations

  import_types Mutations.Cart
  import_types Mutations.Ticket
end
