defmodule JustTravel.Repo.Migrations.CreateTicketPriceTable do
  use Ecto.Migration

  def change do
    up = "CREATE TYPE ticket_category as ENUM ('children', 'adult')"
    down = "DROP TYPE ticket_category"

    execute(up, down)

    create table(:ticket_prices, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :category, :ticket_category
      add :price, :integer
      add :ticket_id, references(:tickets, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end
  end
end
