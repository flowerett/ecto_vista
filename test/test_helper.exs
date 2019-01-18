Logger.configure(level: :info)
ExUnit.start()

Code.require_file("support/test_repo.exs", __DIR__)

alias Ecto.Integration.TestRepo

Application.put_env(
  :dummy_vista,
  TestRepo,
  url: "ecto://postgres:postgres@localhost/ecto_vista_test",
  pool: Ecto.Adapters.SQL.Sandbox
)

# Prepare repository
_ = Ecto.Adapters.Postgres.storage_down(TestRepo.config())
:ok = Ecto.Adapters.Postgres.storage_up(TestRepo.config())

{:ok, _pid} = TestRepo.start_link()

Code.require_file("support/ecto_migration.exs", __DIR__)

:ok = Ecto.Migrator.up(TestRepo, 0, Ecto.Integration.Migration, log: false)
:ok = Ecto.Adapters.SQL.Sandbox.mode(TestRepo, :manual)
Process.flag(:trap_exit, true)
