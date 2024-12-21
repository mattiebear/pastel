defmodule Pastel.Todo.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :name, :string

    has_many :list_users, Pastel.Todo.ListUser
    has_many :users, through: [:list_users, :user]
    has_many :tasks, Pastel.Todo.Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
