# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pastel.Repo.insert!(%Pastel.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Pastel.Accounts
alias Pastel.Todo

# Create a user
{:ok, user} =
  Accounts.register_user(%{
    email: "user@example.com",
    password: "password1234"
  })

Todo.init_user_list!(user)
