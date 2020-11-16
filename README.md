# EctoVista - PostgreSQL views for Ecto

[![Elixir CI](https://github.com/flowerett/ecto_vista/workflows/Elixir%20CI/badge.svg)](https://github.com/flowerett/ecto_vista/actions)
[![Module Version](https://img.shields.io/hexpm/v/ecto_vista.svg)](https://hex.pm/packages/ecto_vista)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ecto_vista/)
[![Total Download](https://img.shields.io/hexpm/dt/ecto_vista.svg)](https://hex.pm/packages/ecto_vista)
[![License](https://img.shields.io/hexpm/l/ecto_vista.svg)](https://github.com/flowerett/ecto_vista/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/flowerett/ecto_vista.svg)](https://github.com/flowerett/ecto_vista/commits/master)

![Landscape](https://pp.userapi.com/c1111/u5935491/11475271/x_d17f8ffd.jpg)

Useful methods to define and manage PostgreSQL views in Ecto.

Inspired by [scenic](https://github.com/scenic-views/scenic) library for ActiveRecord (RoR)

## Installation

Add `:ecto_vista` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_vista, "~> 0.2.0"}
  ]
end
```

<!-- MDOC !-->

## Using EctoVista

To use `EctoVista`, you need to add `use EctoVista` to your Elixir files. This
gives you access to the functions and macros defined in the module.

```elixir
def App.Catalog do
  use Ecto.Schema
  use EctoVista,
    repo: App.Repo
    table_name: "catalog"

  schema @table_name do
    field(:name, :string)
    field(:product_count, :integer)
  end
end
```

The `@table_name` will be defined in macro as `{table_name}_v{version}`
(version is 1 by default) This naming convention facilitates 0-downtime view
updates and will be handled automagically in future versions.

## Generating Views

Views can be generated via regular migration, just put the definition inside
`change` or `up` migration methods.

For the schema definition like the one above, view can be generated as:

```elixir
execute(\"\"\"
  CREATE MATERIALIZED VIEW catalog_v1 AS
    SELECT c.*, count(p.id) AS product_count
    FROM categories c
    LEFT JOIN products p ON c.id = p.category_id
    GROUP BY c.id
  ;
\"\"\")
```

## Updating Views

If you need to update the view, generate a new migration and then just update
the version number in the schema definition:

```elixir
def App.Catalog do
  use Ecto.Schema
  use EctoVista,
    repo: App.Repo
    table_name: "catalog"
    version: 2

  ...
end
```

## Refreshing Views

Use the `refresh/0` function. It will run `REFRESH MATERIALIZED VIEW
[view_name];` query.

```elixir
iex> Catalog.refresh
:ok
```
<!-- MDOC !-->

## Roadmap

### M1

- [x] Support `Model.refresh` callback in Ecto.Schema for Materialized Views
- [x] Implement automatic view versioning for a model
- [ ] Support `create view` callback in Ecto.Migration

### M2
- [ ] Support all options to refresh and create views
- [ ] Implement automatic view versioning for migration

## License

The source code is under the Apache 2 License.
Copyright ©2019 Nikolai Chernyshev
