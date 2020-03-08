defmodule Trackr.Repo do
  use Ecto.Repo,
    otp_app: :trackr,
    adapter: Ecto.Adapters.Postgres
end
