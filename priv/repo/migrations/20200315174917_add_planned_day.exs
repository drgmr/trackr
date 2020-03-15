defmodule Trackr.Repo.Migrations.AddPlannedDay do
  use Ecto.Migration

  def change do
    create table(:planned_days, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :weekday, :string, null: false
      add :description, :string, null: false

      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end
  end
end
