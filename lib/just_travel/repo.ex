defmodule JustTravel.Repo do
  use Ecto.Repo,
    otp_app: :just_travel,
    adapter: Ecto.Adapters.Postgres
end
