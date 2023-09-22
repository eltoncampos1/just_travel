defmodule JustTravel.Repo.Migrations.CreateTicketDiscountsTable do
  use Ecto.Migration

  def change do
    create table(:ticket_discounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :discount_name, :string
      add :discount_amount, :integer
      add :ticket_id, references(:tickets, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end
  end
end
