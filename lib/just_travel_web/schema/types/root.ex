defmodule JustTravelWeb.Schema.Types.Root do
  use Absinthe.Schema.Notation

  alias JustTravelWeb.Schema.Types

  import_types Types.Location

  object :root_query do
    field :test, type: :string do
      resolve fn _, _ -> {:ok, "deu bom"} end
    end
  end
end
