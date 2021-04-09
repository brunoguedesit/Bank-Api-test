# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ex_money,
  default_cldr_backend: StoneBank.Cldr

config :ex_cldr,
  json_library: Jason

config :stone_bank,
  ecto_repos: [StoneBank.Repo]

# Configures the endpoint
config :stone_bank, StoneBankWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DE8H7AJnGOml3Qwl6aZNGxwp45dtnM2fIFtN9hgEm/0yN7xbNYtLc0MfyBK1MvRE",
  render_errors: [view: StoneBankWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: StoneBank.PubSub,
  live_view: [signing_salt: "0m78oPaI"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

if Mix.env() == :test do
  config :junit_formatter,
    report_dir: "/tmp/stone-bank-test-results/exunit/"
end

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
