defmodule TrackrWeb.Schema do
  @moduledoc """
  Specifies the GraphQL schema exposed by the application.
  """
  use Absinthe.Schema

  import_types TrackrWeb.Schema.SchedulingTypes

  query do
    import_fields :scheduling_queries
  end
end
