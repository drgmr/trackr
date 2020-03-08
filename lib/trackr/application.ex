defmodule Trackr.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Trackr.Repo,
      TrackrWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Trackr.Supervisor]

    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TrackrWeb.Endpoint.config_change(changed, removed)

    :ok
  end
end
