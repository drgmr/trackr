defmodule Trackr.Repo.Migrations.AddPastDay do
  use Ecto.Migration

  def change do
    create table(:past_days, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :date, null: false

      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end
  end
end
