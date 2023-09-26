defmodule JustTravel.Schemas.Ticket.Repository do
  alias JustTravel.Schemas.Ticket
  alias JustTravel.Repo
  alias JustTravel.Schemas

  import Ecto.Query

  @spec list_tickets_by_location_name(location_name :: String.t()) ::
          list(Schemas.Ticket.t()) | []
  def list_tickets_by_location_name(location_name, preloads \\ []) do
    from(tkt in Schemas.Ticket, as: :ticket)
    |> join(:left, [ticket: tkt], loc in Schemas.Location,
      as: :location,
      on: loc.id == tkt.location_id
    )
    |> Schemas.Location.Query.by_location_name(location_name)
    |> select([ticket: tkt], tkt)
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def by_ticket_id(ticket_id, preloads \\ []) do
    from(tkt in Schemas.Ticket, as: :ticket)
    |> Schemas.Ticket.Query.by_ticket_id(ticket_id)
    |> Repo.one()
    |> Repo.preload(preloads)
    |> case do
      nil -> {:error, :not_found}
      %Schemas.Ticket{} = ticket -> {:ok, ticket}
    end
  end

  def list() do
    Repo.all(Ticket)
    |> Repo.preload([:location, :price, :discount])
  end

  def list(filters) when is_map(filters) do
    from(tkt in Schemas.Ticket, as: :ticket)
    |> join_location()
    |> apply_filters(filters)
    |> maybe_paginate?(filters)
    |> Repo.all()
    |> Repo.preload([:location, :price, :discount])
  end

  defp join_location(queryable) do
    queryable
    |> join(:left, [ticket: tkt], loc in Schemas.Location,
      as: :location,
      on: loc.id == tkt.location_id
    )
  end

  defp apply_filters(queryable, filters) when is_map(filters) do
    Enum.reduce(filters, queryable, &filter/2)
  end

  defp filter({:location_name, location_name}, queryable),
    do: Schemas.Location.Query.by_location_name(queryable, location_name)

  defp filter({:id, id}, queryable), do: Schemas.Ticket.Query.by_ticket_id(queryable, id)
  defp filter(_invalid_filter, queryable), do: queryable

  defp maybe_paginate?(queryable, %{paginate: paginate}),
    do: JustTravel.Utils.Repo.paginate(queryable, paginate)

  defp maybe_paginate?(queryable, _), do: queryable
end
