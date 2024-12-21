defmodule Pastel.Repo.Migrations.CreateListUsers do
  use Ecto.Migration

  def change do
    create table(:list_users) do
      add :role, :integer, null: false, default: 0

      add :list_id, references(:lists, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:list_users, [:list_id, :user_id])
    create index(:list_users, [:user_id])
  end
end
