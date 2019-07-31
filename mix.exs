defmodule Okta.MixProject do
  use Mix.Project

  def project do
    [
      app: :okta,
      version: "0.1.1",
      elixir: "~> 1.9-rc",
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
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:tesla, "~> 1.2.0"},
      {:hackney, "~> 1.14.0"},
      {:jason, ">= 1.0.0"},
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
