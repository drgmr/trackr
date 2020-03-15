defmodule TrackrWeb.Schema.SchedulingResolvers do
  alias Trackr.Scheduling

  def resolve_blocks(_parent, _args, %{context: %{claims: claims}}) do
    {:ok, Scheduling.fetch_blocks(claims["sub"])}
  end
end
