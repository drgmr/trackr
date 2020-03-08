defmodule TrackrWeb.Router do
  use TrackrWeb, :router

  pipeline :api do
    plug :accepts, ["json"]

    plug TrackrWeb.Context
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql",
            Absinthe.Plug.GraphiQL,
            schema: TrackrWeb.Schema,
            interface: :advanced

    forward "/",
            Absinthe.Plug,
            schema: TrackrWeb.Schema
  end
end
