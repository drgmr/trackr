defmodule TrackrWeb.Router do
  use TrackrWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TrackrWeb do
    pipe_through :api
  end
end
