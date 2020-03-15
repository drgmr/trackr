defmodule Trackr.Scheduling.PlannedDay do
  @moduledoc """
  Represents a day that has an execution plan.
  """
  use Ecto.Schema

  alias Trackr.Accounts.User

  import Ecto.Changeset

  @required_fields [:weekday, :description, :user_id]
  @fields @required_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "planned_days" do
    field :weekday, :string
    field :description, :string

    belongs_to :user, User, type: :binary_id

    timestamps()
  end

  def changeset(target \\ %__MODULE__{}, changes) do
    target
    |> cast(changes, @fields)
    |> validate_required(@required_fields)
  end
end
