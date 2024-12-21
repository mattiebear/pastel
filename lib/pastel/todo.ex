defmodule Pastel.Todo do
  alias Pastel.Repo
  alias Pastel.Accounts.User
  alias Pastel.Todo.Task

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def create_task(%User{} = user, attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end
end
