defmodule Pastel.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :completed_at, :utc_datetime
    field :due_at, :utc_datetime
    field :important, :boolean, default: false

    # While building the schema store the relative time (ex. Tomorrow) as a
    # faster way to set the due date. This will be converted to a real datetime
    # when the task is saved.
    field :relative_due_date, :string, virtual: true

    belongs_to :list, Pastel.Todo.List
    belongs_to :creator, Pastel.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :completed_at, :relative_due_date, :list_id])
    |> validate_required([:name])
    |> validate_length(:name, min: 1)
    |> foreign_key_constraint(:list_id)
  end
end
