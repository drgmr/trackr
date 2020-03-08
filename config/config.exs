use Mix.Config

config :trackr,
  ecto_repos: [Trackr.Repo],
  generators: [binary_id: true]

config :trackr, TrackrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MGOaVzqWL5S5XYFDzDn7KQw4hYa9r/0H0v/vE3fCU3wHLJQN/X6rvAhXiXlALPha",
  render_errors: [view: TrackrWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Trackr.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "aIcgM5Ex"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
