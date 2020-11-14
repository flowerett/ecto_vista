defmodule EctoVista do
  @moduledoc """
  Provides the macros and functions to define and manage
  PostgreSQL views with Ecto.

  ## Using EctoVista

    To use `EctoVista`, you need to add `use EctoVista` to your Elixir
    files. This gives you access to the functions and macros defined
    in the module.

    example:
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

    The `@table_name` will be defined in macro as `{table_name}_v{version}` (version is 1 by default)
    This naming convention facilitates 0-downtime view updates and will be handled automagically in future versions.

    ## Generating Views

      Views can be generated via regular migration, just put the definition inside `change` or `up` migration methods.
      For the schema definition like the one above, view can be generated as:

      execute(\"\"\"
        CREATE MATERIALIZED VIEW catalog_v1 AS
          SELECT c.*, count(p.id) AS product_count
          FROM categories c
          LEFT JOIN products p ON c.id = p.category_id
          GROUP BY c.id
        ;
      \"\"\")


  ## Updating Views

    If you need to update the view, generate a new migration and then just update the version number in the schema definition:

      def App.Catalog do
        use Ecto.Schema
        use EctoVista,
          repo: App.Repo
          table_name: "catalog"
          version: 2

        ...
      end

  ## Refreshing Views

    Use the `refresh/0` function
    It will run `REFRESH MATERIALIZED VIEW [view_name];` query.

      iex> Catalog.refresh
      :ok
  """

  require Ecto.Query

  defmacro __using__(opts \\ []) do
    unless repo = Keyword.get(opts, :repo) do
      raise ArgumentError,
            """
            expected :repo to be given as an option. Example:
            use EctoVista, repo: App.Repo
            """
    end

    unless table_name = Keyword.get(opts, :table_name) do
      raise ArgumentError,
            """
            expected :table_name to be given as an option. Example:
            use EctoVista, table_name: "categories"
            """
    end

    version = Keyword.get(opts, :version, 1)

    quote do
      import Ecto

      @table_name "#{unquote(table_name)}_v#{unquote(version)}"

      def repo, do: unquote(repo)

      def source, do: __MODULE__.__struct__().__meta__.source

      @doc """
      A function that refreshes a current version of the view,
      defined in module.
      Currently support only materialized views.

        iex> Catalog.refresh
        :ok
      """
      @spec refresh() :: :ok | {:error, String.t()}
      def refresh do
        @table_name
        |> refresh_query()
        |> repo().query()
        |> handle_refresh_result()
      end

      defp refresh_query(name) do
        "REFRESH MATERIALIZED VIEW #{name};"
      end

      defp handle_refresh_result({:ok, _}), do: :ok

      defp handle_refresh_result({:error, %Postgrex.Error{postgres: error_hash}}) do
        {:error, error_hash.message}
      end
    end
  end
end
