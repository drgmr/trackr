defmodule Trackr.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :nickname, :string, null: false

      timestamps()
    end
  end
end
