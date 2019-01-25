defmodule EctoVista.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :ecto_vista,
      version: @version,
      elixir: "~> 1.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      description: "PG Views support for Ecto",
      package: package(),

      # Docs
      name: "Ecto.Vista",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:inch_ex, ">= 0.0.0", only: :docs}
    ]
  end

  defp package do
    [
      maintainers: ["Nick Chernyshev"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/flowerett/ecto_vista"},
      files: ~w(.formatter.exs mix.exs README.md lib)
    ]
  end

  defp docs do
    [
      main: "Ecto.Vista",
      source_url: "https://github.com/flowerett/ecto_vista"
    ]
  end
end
