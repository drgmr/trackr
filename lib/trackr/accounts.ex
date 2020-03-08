defmodule Trackr.Accounts do
  @spec get_user(Ecto.UUID.t()) :: {:ok, term()} | {:error, :not_found}
  def get_user(_id) do
    {:ok, :user}
  end
end
