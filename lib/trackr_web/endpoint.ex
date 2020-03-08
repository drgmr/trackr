defmodule TrackrWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :trackr

  @session_options [
    store: :cookie,
    key: "_trackr_key",
    signing_salt: "fu/jT02H"
  ]

  plug Plug.Static,
    at: "/",
    from: :trackr,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session, @session_options

  plug TrackrWeb.Router
end
