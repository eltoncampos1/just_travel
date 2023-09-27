# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :just_travel,
  ecto_repos: [JustTravel.Repo]

host = System.get_env("PHX_HOST") || "localhost"
port = String.to_integer(System.get_env("PORT") || "4000")

# Configures the endpoint
config :just_travel, JustTravelWeb.Endpoint,
  url: [host: host, port: port],
  render_errors: [
    formats: [html: JustTravelWeb.ErrorHTML, json: JustTravelWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: JustTravel.PubSub,
  live_view: [signing_salt: "0SD8j134"],
  check_origin: [
        "https://just-travel.gigalixirapp.com/",
        "//just-travel.gigalixirapp.com/",
        "//.*just-travel.gigalixirapp.com/",
        "//localhost"
      ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :just_travel, JustTravel.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.1.8",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :money,
  default_currency: :BRL

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
