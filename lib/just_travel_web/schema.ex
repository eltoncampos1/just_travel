defmodule JustTravelWeb.Schema do
  use Absinthe.Schema
  import_types Absinthe.Type.Custom
  import_types JustTravelWeb.Schema.Types.Root

  query do
    import_fields :root_query
  end
end
