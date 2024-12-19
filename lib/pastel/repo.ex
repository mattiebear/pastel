defmodule Pastel.Repo do
  use Ecto.Repo,
    otp_app: :pastel,
    adapter: Ecto.Adapters.Postgres
end
