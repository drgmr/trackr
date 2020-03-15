defmodule Trackr.Scheduling.PastDay do
  @moduledoc """
  Represents a day in the past.
  """
  use Ecto.Schema

  alias Trackr.Accounts.User

  import Ecto.Changeset

  @required_fields [:date, :user_id]
  @fields @required_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "past_days" do
    field :date, :date

    belongs_to :user, User, type: :binary_id

    timestamps()
end

  def changeset(target \\ %__MODULE__{}, changes) do
    target
    |> cast(changes, @fields)
    |> validate_required(@required_fields)
  end
end
