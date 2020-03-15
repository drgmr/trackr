defmodule Trackr.Repo.Migrations.AddDaySchedule do
  use Ecto.Migration

  def change do
    create table(:day_schedules, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start_time, :time, null: false
      add :end_time, :time, null: false

      add :planned_day_id, references(:planned_days, type: :binary_id)
      add :block_id, references(:blocks, type: :binary_id)

      timestamps()
    end
  end
end
