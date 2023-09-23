defmodule JustTravel.Ticket.Services.ListById do
  alias JustTravel.Schemas

  @spec execute(id :: String.t()) ::
          {:ok, list(Schemas.Ticket.t())} | {:error, :not_found} | {:error, :invalid_id}
  def execute(id) when is_binary(id) do
    with {:ok, id} <- check_uuid(id),
         {:ok, ticket} <- Schemas.Ticket.Repository.by_ticket_id(id) do
      {:ok, ticket}
    end
  end

  defp check_uuid(id) do
    case Ecto.UUID.cast(id) do
      :error -> {:error, :invalid_id}
      {:ok, id} -> {:ok, id}
    end
  end
end
