defmodule Pastel.Todo do
  alias Pastel.Todo.Task

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end
end
