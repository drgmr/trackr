defmodule Trackr.Scheduling do
  @moduledoc """
  Provides actions over scheduling resources.
  """
  import Ecto.Query

  alias Trackr.Repo
  alias Trackr.Scheduling.{Block, DaySchedule, PastDay, PlannedDay}

  @spec create_block(map()) :: {:ok, Block.t()} | {:error, Ecto.Changeset.t()}
  def create_block(params) do
    with %{valid?: true} = changeset <- Block.changeset(params),
         {:ok, result} <- Repo.insert(changeset) do
      {:ok, result}
    else
      {:error, _reason} = error ->
        error

      reason ->
        {:error, reason}
    end
  end

  @spec fetch_blocks(Ecto.UUID.t()) :: [Block.t()]
  def fetch_blocks(user_id) do
    Block
    |> where([block], block.user_id == ^user_id)
    |> Repo.all()
  end

  @spec create_planned_day(map()) :: {:ok, PlannedDay.t()} | {:error, Ecto.Changeset.t()}
  def create_planned_day(params) do
    with %{valid?: true} = changeset <- PlannedDay.changeset(params),
         {:ok, result} <- Repo.insert(changeset) do
      {:ok, result}
    else
      {:error, _reason} = error ->
        error

      reason ->
        {:error, reason}
    end
  end

  @spec fetch_planned_days(Ecto.UUID.t()) :: [PlannedDay.t()]
  def fetch_planned_days(user_id) do
    PlannedDay
    |> where([planned_day], planned_day.user_id == ^user_id)
    |> Repo.all()
  end

  @spec create_day_schedule(map()) :: {:ok, DaySchedule.t()} | {:error, Ecto.Changeset.t()}
  def create_day_schedule(params) do
    with %{valid?: true} = changeset <- DaySchedule.changeset(params),
         {:ok, result} <- Repo.insert(changeset),
         result = Repo.preload(result, [:block, :planned_day]) do
      {:ok, result}
    else
      {:error, _reason} = error ->
        error

      reason ->
        {:error, reason}
    end
  end

  @spec fetch_day_schedules(Ecto.UUID.t()) :: [DaySchedule.t()]
  def fetch_day_schedules(user_id) do
    DaySchedule
    |> join(:inner, [day_schedule], block in Block,
      on: day_schedule.block_id == block.id,
      as: :block
    )
    |> join(:inner, [day_schedule], planned_day in PlannedDay,
      on: day_schedule.planned_day_id == planned_day.id,
      as: :planned_day
    )
    |> where(
      [block: block, planned_day: planned_day],
      block.user_id == planned_day.user_id and block.user_id == ^user_id
    )
    |> Repo.all()
    |> Repo.preload([:block, :planned_day])
  end

  @spec create_past_day(map()) :: {:ok, PastDay.t()} | {:error, Ecto.Changeset.t()}
  def create_past_day(params) do
    with %{valid?: true} = changeset <- PastDay.changeset(params),
         {:ok, result} <- Repo.insert(changeset) do
      {:ok, result}
    else
      {:error, _reason} = error ->
        error

      reason ->
        {:error, reason}
    end
  end

  @spec fetch_past_days(Ecto.UUID.t()) :: [PastDay.t()]
  def fetch_past_days(user_id) do
    PastDay
    |> where([past_day], past_day.user_id == ^user_id)
    |> Repo.all()
  end
end
