defmodule Trackr.Scheduling.Block do
  @moduledoc """
  Represents a time block - a task that needs to be done,
  part of the planning process and also the historical registry.
  """
  use Ecto.Schema

  alias Trackr.Accounts.User

  import Ecto.Changeset

  @required_fields [:name, :description, :category, :user_id]
  @fields @required_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "blocks" do
    field :name, :string
    field :description, :string
    field :category, :string

    belongs_to :user, User, type: :binary_id
  end

  def changeset(target \\ %__MODULE__{}, changes) do
    target
    |> cast(changes, @fields)
    |> validate_required(@required_fields)
  end
end
