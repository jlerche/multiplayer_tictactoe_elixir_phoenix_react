defmodule Tee.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
      add :full, :boolean, default: false, null: false
      add :winner, :string

      timestamps()
    end

  end
end
