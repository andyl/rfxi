# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :rfxi, RfxiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2bXJUHIElq8MeiPI2D/udnCx5vWVdeP2dWAhPJVuiY+S1iLxF8doRoxBMgzW7x4v",
  render_errors: [view: RfxiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Rfxi.PubSub,
  # server: true, 
  live_view: [signing_salt: "XQMa67JV"]

config :rfxi, 
  env: Mix.env()

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Clear screen before every test run
if Mix.env == :dev do
  config :mix_test_interactive, clear: true
end



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
