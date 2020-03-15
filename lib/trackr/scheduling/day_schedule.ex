defmodule Trackr.Scheduling.DaySchedule do
  @moduledoc """
  Defines an allocated slice of time on a
  given Planned Day by associating it with a Block.
  """
  use Ecto.Schema

  alias Trackr.Scheduling.{Block, PlannedDay}

  import Ecto.Changeset

  @required_fields [:start_time, :end_time, :planned_day_id, :block_id]
  @fields @required_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "day_schedules" do
    field :start_time, :time
    field :end_time, :time

    belongs_to :block, Block, type: :binary_id
    belongs_to :planned_day, PlannedDay, type: :binary_id

    timestamps()
  end

  def changeset(target \\ %__MODULE__{}, changes) do
    target
    |> cast(changes, @fields)
    |> validate_required(@required_fields)
  end
end
