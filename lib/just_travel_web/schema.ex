defmodule JustTravelWeb.Schema do
  use Absinthe.Schema
  import_types Absinthe.Type.Custom
  import_types JustTravelWeb.Schema.Types.Root
  import_types AbsintheErrorPayload.ValidationMessageTypes

  query do
    import_fields :root_queries
  end

  mutation do
    import_fields :root_mutations
  end
end
