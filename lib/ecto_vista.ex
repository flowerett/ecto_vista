defmodule EctoVista do
  @moduledoc """
  Provides the macros and functions to define and manage
  PostgreSQL views with Ecto.
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
