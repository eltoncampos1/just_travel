defmodule JustTravel.Ticket.Services.ListByFilters do
  alias JustTravel.Schemas.Ticket.Repository
  alias JustTravel.Ticket.Commands

  @spec execute(filters :: Commands.ListByFilters.t()) ::
          {:ok, tickets: list(), total: integer} | {:error, term()} | nil | []
  def execute(%Commands.ListByFilters{} = filters) do
    filters
    |> sanitize_filters()
    |> Repository.list()
  end

  defp sanitize_filters(map) when is_struct(map) do
    map
    |> Map.from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new(fn {k, v} -> {k, v} end)
  end
end
