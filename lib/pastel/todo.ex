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

  def get_task!(%User{} = _user, id) do
    # TODO: Authorize user
    Repo.get_by!(Task, id: id)
  end

  def list_tasks(%User{} = user) do
    Repo.all(
      from t in Task,
        join: l in List,
        on: t.list_id == l.id,
        join: lu in ListUser,
        on: lu.list_id == l.id,
        where: lu.user_id == ^user.id
    )
  end

  def complete_task!(%Task{} = task) do
    task
    |> Changeset.change(%{completed_at: DateTime.utc_now() |> DateTime.truncate(:second)})
    |> Repo.update!()
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
