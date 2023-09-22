defmodule JustTravel.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      JustTravelWeb.Telemetry,
      # Start the Ecto repository
      JustTravel.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: JustTravel.PubSub},
      # Start Finch
      {Finch, name: JustTravel.Finch},
      # Start the Endpoint (http/https)
      JustTravelWeb.Endpoint
      # Start a worker by calling: JustTravel.Worker.start_link(arg)
      # {JustTravel.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JustTravel.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JustTravelWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
