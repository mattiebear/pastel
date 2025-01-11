defmodule Pastel.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :completed_at, :utc_datetime
    field :due_on, :date
    field :important, :boolean, default: false

    # While building the schema store the relative time (ex. Tomorrow) as a
    # faster way to set the due date. This will be converted to a real datetime
    # when the task is saved.
    field :relative_due_on, :string, virtual: true

    belongs_to :list, Pastel.Todo.List
    belongs_to :creator, Pastel.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :completed_at, :relative_due_on, :list_id])
    |> trim(:name)
    |> trim(:description)
    |> validate_required([:name])
    |> validate_length(:name, min: 1)
    |> foreign_key_constraint(:list_id)
  end

  def create_changeset(task, attrs, user) do
    task
    |> changeset(attrs)
    |> put_due_on(attrs, user)
  end

  defp trim(changeset, field) do
    update_change(changeset, field, &normalize_string/1)
  end

  defp normalize_string(string) when is_binary(string), do: String.trim(string)
  defp normalize_string(string) when is_nil(string), do: nil

  defp put_due_on(changeset, attrs, user) do
    today = DateTime.now!(user.time_zone) |> DateTime.to_date()
    day_of_week = Date.day_of_week(today)

    due_on =
      case attrs["relative_due_on"] do
        "today" ->
          today

        "this_week" ->
          Date.end_of_week(today, :monday) |> Date.add(if day_of_week > 5, do: 7, else: 0)

        "later" ->
          Date.add(today, 30)

        _ ->
          nil
      end

    put_change(changeset, :due_on, due_on)
  end
end
