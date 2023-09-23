defmodule JustTravelWeb.Schema.Types.Root do
  use Absinthe.Schema.Notation

  alias JustTravelWeb.Schema.Types
  alias JustTravelWeb.Schema.Queries

  import_types Types.Location
  import_types Types.Ticket
  import_types Queries.Ticket

  object :root_query do
    import_fields :tickets
  end
end
