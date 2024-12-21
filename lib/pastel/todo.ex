defmodule Pastel.Todo do
  alias Ecto.Changeset
  alias Pastel.Repo
  alias Pastel.Accounts.User
  alias Pastel.Todo.List
  alias Pastel.Todo.Task
  alias Pastel.Todo.ListUser

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def create_task(%User{} = user, attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def init_user_list(%User{} = user) do
    Changeset.change(%ListUser{})
    |> Changeset.put_change(:role, :owner)
    |> Changeset.put_assoc(:user, user)
    |> Changeset.put_assoc(:list, %List{name: "My List", type: :private})
    |> Repo.insert()
  end
end
