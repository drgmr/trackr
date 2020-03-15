defmodule Trackr.Scheduling.DayRegistry do
  @moduledoc """
  Represents time spent on a PastDay by associating it to a Block.
  """
  use Ecto.Schema

  alias Trackr.Scheduling.{Block, PastDay}

  import Ecto.Changeset

  @required_fields [:start_time, :end_time, :notes, :past_day_id, :block_id]
  @fields @required_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "day_registries" do
    field :start_time, :time
    field :end_time, :time
    field :notes, :string

    belongs_to :block, Block, type: :binary_id
    belongs_to :past_day, PastDay, type: :binary_id

    timestamps()
  end

  def changeset(target \\ %__MODULE__{}, changes) do
    target
    |> cast(changes, @fields)
    |> validate_required(@required_fields)
  end
end
