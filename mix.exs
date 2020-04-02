defmodule Okta.MixProject do
  use Mix.Project

  def project do
    [
      app: :okta_api,
      version: "0.1.10",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/variance-inc/okta-elixir",
      docs: [main: "Okta"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:tesla, :hackney, :logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:tesla, "~> 1.3"},
      {:hackney, "~> 1.15"},
      {:jason, ">= 1.0.0"},
      {:plug, "~> 1.8", optional: true},
      {:mox, "~> 0.5", only: :test}
    ]
  end

  defp description do
    "Elixir SDK for Okta APIs"
  end

  defp package do
    [
      name: "okta_api",
      # These are the default files included in the package
      files: ~w(lib config .formatter.exs mix.exs README* LICENSE* ),
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/variance-inc/okta-elixir"}
    ]
  end
end
