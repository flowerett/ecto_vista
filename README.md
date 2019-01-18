# EctoVista

PG Views support for Ecto

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_vista` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_vista, "~> 0.1.0"}
  ]
end
```

## Basic Usage

```
def App.Catalog do
  use Ecto.Schema
  use EctoVista, repo: App.Repo

  # schema definitions
end

iex> Catalog.refresh
{:ok, :success}
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ecto_vista](https://hexdocs.pm/ecto_vista).

## License

The source code is under the Apache 2 License.
