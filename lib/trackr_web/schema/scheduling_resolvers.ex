defmodule TrackrWeb.Schema.SchedulingResolvers do
  @moduledoc """
  Resolves all operations related to Scheduling.
  """

  def resolve_blocks(_parent, _args, %{context: %{claims: claims}}) do
    {:ok, Trackr.fetch_blocks(claims["sub"])}
  end

  def create_block(_parent, args, %{context: %{claims: claims}}) do
    params = Map.put(args, :user_id, claims["sub"])

    Trackr.create_block(params)
  end

  def resolve_planned_days(_parent, _args, %{context: %{claims: claims}}) do
    {:ok, Trackr.fetch_planned_days(claims["sub"])}
  end

  def create_planned_day(_parent, args, %{context: %{claims: claims}}) do
    params = Map.put(args, :user_id, claims["sub"])

    Trackr.create_planned_day(params)
  end

  def resolve_day_schedules(_parent, _args, %{context: %{claims: claims}}) do
    {:ok, Trackr.fetch_day_schedules(claims["sub"])}
  end

  def create_day_schedule(_parent, args, %{context: %{claims: claims}}) do
    params = Map.put(args, :user_id, claims["sub"])

    Trackr.create_day_schedule(params)
  end
end
