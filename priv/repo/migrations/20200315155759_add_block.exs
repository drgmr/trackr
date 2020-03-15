defmodule Trackr.Repo.Migrations.AddBlock do
  use Ecto.Migration

  def change do
    create table(:blocks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :string, null: false
      add :category, :string, null: false

      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end
  end
end
