defmodule Ecto.Integration.TestRepo do
  use Ecto.Repo,
    otp_app: :dummy_vista,
    adapter: Ecto.Adapters.Postgres
end
