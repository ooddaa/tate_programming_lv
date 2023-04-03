defmodule Help.Repo do
  use Ecto.Repo,
    otp_app: :help,
    adapter: Ecto.Adapters.Postgres
end
