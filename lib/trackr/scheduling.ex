defmodule Trackr.Scheduling do
  @moduledoc """
  Provides actions over scheduling resources.
  """
  import Ecto.Query

  alias Trackr.Repo
  alias Trackr.Scheduling.{Block, PlannedDay}

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
    |> where([block], block.user_id == ^user_id)
    |> Repo.all()
  end
end
