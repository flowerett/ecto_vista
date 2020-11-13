defmodule EctoVista.MixProject do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :ecto_vista,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),

      # Hex
      description: "PG Views support for Ecto",
      package: package(),

      # Docs
      name: "Ecto.Vista",
      source_url: "https://github.com/flowerett/ecto_vista",
      homepage_url: "https://github.com/flowerett/ecto_vista",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def aliases do
    [
      lint: [
        "hex.audit",
        "deps.unlock --unused",
        "format --check-formatted --dry-run",
        "credo --strict"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.5"},
      {:ecto_sql, "~> 3.5"},
      {:postgrex, "~> 0.15"},

      # Dev dependencies
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},

      # Docs dependencies
      {:ex_doc, "~> 0.23", only: :docs},
      {:inch_ex, "~> 2.0", only: :docs}
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
