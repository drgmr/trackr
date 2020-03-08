defmodule TrackrWeb.Schema do
  @moduledoc """
  Specifies the GraphQL schema exposed by the application.
  """
  use Absinthe.Schema

  query do
    field :id, :id do
      resolve(&gen/3)
    end
  end

  defp gen(_, _, _) do
    id = Ecto.UUID.generate()

    {:ok, id}
  end
end
