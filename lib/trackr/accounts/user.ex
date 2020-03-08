defmodule Trackr.Accounts.User do
  @moduledoc """
  Represents an authorized user of the system.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @required_fields [:nickname]
  @fields @required_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :nickname, :string

    timestamps()
  end

  def changeset(target \\ %__MODULE__{}, changes) do
    target
    |> cast(changes, @fields)
    |> validate_required(@required_fields)
  end
end
