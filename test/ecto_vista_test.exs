defmodule EctoVistaTest do
  use ExUnit.Case, async: true
  doctest EctoVista

  defmodule Category do
    use Ecto.Schema
    import Ecto.Changeset

    schema "categories" do
      field(:name, :string)
    end

    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:name])
    end
  end

  alias Ecto.Integration.TestRepo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)
  end

  test "it works" do
    %Category{}
    |> Category.changeset(%{name: "test"})
    |> TestRepo.insert()

    assert %Category{name: "test"} = TestRepo.one(Category)
  end
end
