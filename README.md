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

Add `ecto_vista` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_vista, "~> 0.2.0"}
  ]
end
```

## Basic Usage

1. Add `ecto_vista` to your list of dependencies in `mix.exs` and run:

   ```
   mix deps.get
   ```

2. Generate your migration for the view, put the view definition like the one below
inside `change` or `up` method:

   ```
   execute("""
     CREATE MATERIALIZED VIEW catalog_v1 AS
       SELECT c.*, count(p.id) AS product_count
       FROM categories c
       LEFT JOIN products p ON c.id = p.category_id
       GROUP BY c.id
     ;
   """)
   ```

3. Use `EctoVista` module in your Ecto schema:

   ```
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
   (version is 1 by default). This naming convention facilitates 0-downtime view
   updates and will be handled automagically in future versions.

   If you need to update the view, generate a new migration and then just
   update the version number in the schema definition:

   ```
   def App.Catalog do
     use Ecto.Schema
     use EctoVista,
       repo: App.Repo
       table_name: "catalog"
       version: 2

     ...
   end
   ```

4. Don't forget to refresh your materialized view to see data:

   ```
   iex> Catalog.refresh
   :ok
   ```

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
