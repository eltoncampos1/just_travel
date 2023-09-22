defmodule JustTravel.Repo.Migrations.CreateLocationsTable do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :country, :string

      timestamps(type: :utc_datetime_usec)
    end

    create index(:locations, [:name, :country])
  end
end
