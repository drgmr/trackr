defmodule Trackr.Accounts do
  @moduledoc """
  Provides operations over users and other account resources.
  """
  alias Trackr.Repo

  alias Trackr.Accounts.User

  @spec get_user(Ecto.UUID.t()) :: {:ok, term()} | {:error, :not_found}
  def get_user(id) do
    case Repo.get(User, id) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end
end
