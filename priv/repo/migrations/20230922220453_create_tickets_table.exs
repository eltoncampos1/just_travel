defmodule JustTravel.Repo.Migrations.CreateTicketsTable do
  use Ecto.Migration

  def change do
    create table(:tickets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :date, :date
      add :location_id, references(:locations, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end
  end
end
