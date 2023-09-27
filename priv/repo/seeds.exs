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
# end
tickets = JustTravel.Repo.all(Schemas.Ticket) |> Repo.preload(:price)

for t <- tickets do
  if is_nil(t.price) do
    %{
      ticket_id: t.id,
      price: Money.new(:random.uniform(100_000)),
      category: Enum.random([:adult, :children])
    }
    |> JustTravel.Schemas.TicketPrice.changeset()
    |> Repo.insert()
  end
end
