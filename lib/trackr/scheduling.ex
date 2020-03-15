defmodule Trackr.Scheduling do
  @moduledoc """
  Provides actions over scheduling resources.
  """
  alias Trackr.Repo

  alias Trackr.Scheduling.Block

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
end
