defmodule Pastel.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string, null: false
      add :description, :text
      add :completed_at, :utc_datetime
      add :due_at, :utc_datetime
      add :important, :boolean, default: false

      add :creator_id, references(:users, on_delete: :delete_all)
      add :list_id, references(:lists, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:creator_id])
    create index(:tasks, [:list_id])
  end
end
