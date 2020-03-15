defmodule TrackrWeb.Schema.SchedulingResolvers do
  @moduledoc """
  Resolves all operations related to Scheduling.
  """
  alias Trackr.Scheduling

  def resolve_blocks(_parent, _args, %{context: %{claims: claims}}) do
    {:ok, Scheduling.fetch_blocks(claims["sub"])}
  end

  def create_block(_parent, args, %{context: %{claims: claims}}) do
    params = Map.put(args, :user_id, claims["sub"])

    Scheduling.create_block(params)
  end

  def resolve_planned_days(_parent, _args, %{context: %{claims: claims}}) do
    {:ok, Scheduling.fetch_planned_days(claims["sub"])}
  end

  def create_planned_day(_parent, args, %{context: %{claims: claims}}) do
    params = Map.put(args, :user_id, claims["sub"])

    Scheduling.create_planned_day(params)
  end
end
