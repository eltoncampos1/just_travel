defmodule JustTravelWeb.Schema.Types.Root do
  use Absinthe.Schema.Notation

  alias JustTravelWeb.Schema.Types
  alias JustTravelWeb.Schema.Queries
  alias JustTravelWeb.Schema.Mutations

  import_types Types.Location
  import_types Types.Ticket
  import_types Types.Commom
  import_types Types.Cart

  import_types Queries.Ticket
  import_types Queries.Cart
  import_types Mutations.Cart
  import_types Mutations.Ticket

  object :root_queries do
    import_fields :tickets_queries
    import_fields :cart_queries
  end

  object :root_mutations do
    import_fields :cart_mutations
    import_fields :ticket_mutations
  end
end
