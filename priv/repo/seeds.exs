# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     JustTravel.Repo.insert!(%JustTravel.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias JustTravel.Schemas
alias JustTravel.Repo

# location =
#   %{
#     name: "Toronto",
#     country: "canada"
#   }
#   |> Schemas.Location.changeset()
#   |> JustTravel.Repo.insert!()

# for i <- 1..10 do
#   ticket =
#     %{
#       location_id: location.id,
#       name: "lorem ipsum toronto " <> to_string(i),
#       description: "put description here " <> to_string(i),
#       date: Date.utc_today()
#     }
#     |> Schemas.Ticket.changeset()
#     |> JustTravel.Repo.insert!()
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
