use Mix.Config

config :trackr, Trackr.Repo,
  username: "postgres",
  password: "postgres",
  database: "trackr_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :trackr, TrackrWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
