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

location =
  %{
    name: "Toronto",
    country: "canada"
  }
  |> Schemas.Location.changeset()
  |> JustTravel.Repo.insert!()

for i <- 1..10 do
  ticket =
    %{
      location_id: location.id,
      name: "lorem ipsum toronto " <> to_string(i),
      description: "put description here " <> to_string(i),
      date: Date.utc_today()
    }
    |> Schemas.Ticket.changeset()
    |> JustTravel.Repo.insert!()
end
