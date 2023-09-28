defmodule JustTravel.Utils.Repo do
  import Ecto.Query
  alias JustTravel.Schemas
  alias JustTravel.Repo

  def paginate(queryable, opts) do
    page = Map.get(opts, :page, 1)
    per_page = Map.get(opts, :per_page, 10)
    do_paginate(queryable, page, per_page)
  end

  def seeds do
    for _i <- 1..1000 do
      t =
        Enum.random([
          %{city: "Tokyo", country: "japan"},
          %{city: "Osaka", country: "japan"},
          %{city: "Shibuya", country: "japan"},
          %{city: "Hiorshima", country: "Japan"},
          %{city: "Nova york", country: "EUA"},
          %{city: "Disney", country: "EUA"},
          %{city: "Las vegas", country: "EUA"},
          %{city: "California", country: "EUA"},
          %{city: "Orlando", country: "EUA"},
          %{city: "Paris", country: "França"},
          %{city: "Marselha", country: "França"},
          %{city: "Lyon", country: "França"},
          %{city: "Joao pessoa", country: "Brasil"},
          %{city: "Gramado", country: "Brasil"},
          %{city: "Amazonia", country: "Brasil"}
        ])

      location =
        %{
          name: t.city,
          country: t.country
        }
        |> Schemas.Location.changeset()
        |> Repo.insert!()

      ticket =
        %{
          location_id: location.id,
          name: "viagem para #{t.city} - #{t.country}",
          description: "lorem ipsum",
          date: Date.add(Date.utc_today(), :rand.uniform(100))
        }
        |> Schemas.Ticket.changeset()
        |> JustTravel.Repo.insert!()

      category = Enum.random([:adult, :children])

      %{
        category: category,
        price: Money.new(:rand.uniform(10_000)),
        ticket_id: ticket.id
      }
      |> Schemas.TicketPrice.changeset()
      |> Repo.insert()

      %{
        discount_amount: Money.new(:rand.uniform(200)),
        discount_name: "O gerente ficou doido",
        ticket_id: ticket.id
      }
      |> Schemas.TicketDiscount.changeset()
      |> Repo.insert()
    end
  end

  defp do_paginate(queryable, page, per_page) when is_binary(per_page) or is_binary(per_page) do
    page = String.to_integer(page)
    per_page = String.to_integer(per_page)
    do_paginate(queryable, page, per_page)
  end

  defp do_paginate(queryable, page, per_page) when page > 0 do
    offset = per_page * (page - 1)

    from queryable,
      limit: ^per_page,
      offset: ^offset
  end

  defp do_paginate(queryable, _page, per_page), do: do_paginate(queryable, 1, per_page)
end
