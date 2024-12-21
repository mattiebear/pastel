defmodule Pastel.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :name, :string, null: false
      add :type, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end
  end
end
