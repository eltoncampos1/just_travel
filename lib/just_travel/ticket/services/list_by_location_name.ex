defmodule JustTravel.Ticket.Services.ListByLocationName do
  alias JustTravel.Schemas

  @spec execute(location_name :: String.t()) ::
          {:ok, list(Schemas.Ticket.t())} | {:error, :not_found}
  def execute(location_name) when is_binary(location_name) and bit_size(location_name) > 0 do
    case Schemas.Ticket.Repository.list_tickets_by_location_name(location_name) do
      [] -> {:error, :not_found}
      tickets when is_list(tickets) -> {:ok, tickets}
    end
  end

  def execute(_), do: {:error, :not_found}
end
