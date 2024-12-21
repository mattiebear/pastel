defmodule Pastel.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :completed_at, :utc_datetime
    field :due_date, :date

    field :relative_due_date, :string, virtual: true

    belongs_to :user, Pastel.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :completed_at, :relative_due_date])
    |> validate_required([:name])
    |> validate_length(:name, min: 1)
  end
end
