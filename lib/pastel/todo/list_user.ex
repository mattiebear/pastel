defmodule Pastel.Todo.ListUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "list_users" do
    field :role, Ecto.Enum, values: [member: 0, owner: 1], default: :member

    belongs_to :list, Pastel.Todo.List
    belongs_to :user, Pastel.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list_user, attrs) do
    list_user
    |> cast(attrs, [:role])
    |> validate_required([:role])
  end
end
