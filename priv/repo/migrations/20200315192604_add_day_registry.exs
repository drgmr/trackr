defmodule Trackr.Repo.Migrations.AddDayRegistry do
  use Ecto.Migration

  def change do
    create table(:day_registries, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start_time, :time, null: false
      add :end_time, :time, null: false
      add :notes, :string, null: false

      add :past_day_id, references(:past_days, type: :binary_id)
      add :block_id, references(:blocks, type: :binary_id)

      timestamps()
    end
  end
end
