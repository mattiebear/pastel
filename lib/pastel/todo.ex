defmodule Pastel.Todo do
  import Ecto.Query

  alias Ecto.Changeset
  alias Pastel.Repo
  alias Pastel.Accounts.User
  alias Pastel.Todo.{List, ListUser, Task}

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def create_task(%User{} = user, attrs \\ %{}) do
    %Task{}
    |> Task.create_changeset(attrs, user)
    |> Repo.insert()
  end

  def init_user_list!(%User{} = user) do
    Changeset.change(%ListUser{})
    |> Changeset.put_change(:role, :owner)
    |> Changeset.put_assoc(:user, user)
    |> Changeset.put_assoc(:list, %List{name: "My Personal Tasks", type: :private})
    |> Repo.insert!()
  end

  def list_lists(%User{} = user) do
    Repo.all(
      from l in List, join: lu in ListUser, on: lu.list_id == l.id, where: lu.user_id == ^user.id
    )
  end
end
