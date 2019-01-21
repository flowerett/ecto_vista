defmodule EctoVista do
  @moduledoc false

  require Ecto.Query

  defmacro __using__(opts \\ []) do
    unless repo = Keyword.get(opts, :repo) do
      raise ArgumentError,
            """
            expected :repo to be given as an option. Example:
            use EctoVista, repo: App.Repo
            """
    end

    quote do
      import Ecto

      def repo, do: unquote(repo)

      def source, do: __MODULE__.__struct__().__meta__.source

      def refresh do
        source()
        |> refresh_query()
        |> repo().query()
        |> handle_refresh_result()
      end

      defp refresh_query(name) do
        "REFRESH MATERIALIZED VIEW #{name};"
      end

      defp handle_refresh_result({:ok, _}), do: {:ok, :success}

      defp handle_refresh_result({:error, %Postgrex.Error{postgres: error_hash}}) do
        {:error, error_hash.message}
      end
    end
  end
end
