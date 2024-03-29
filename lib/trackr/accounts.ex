defmodule Trackr.Accounts do
  @moduledoc """
  Provides operations over users and other account resources.
  """
  alias Trackr.Repo

  alias Trackr.Accounts.User

  @spec get_user(Ecto.UUID.t()) :: {:ok, User.t()} | {:error, :not_found}
  def get_user(id) do
    case Repo.get(User, id) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @spec create_user() :: User.t()
  def create_user do
    moment =
      DateTime.utc_now()
      |> DateTime.to_iso8601()

    params = %{nickname: "user_#{moment}"}

    %User{}
    |> User.changeset(params)
    |> Repo.insert!()
  end
end
