defmodule Okta.MixProject do
  use Mix.Project

  @source_url "https://github.com/variance-inc/okta-elixir"
  @version "0.1.14"

  def project do
    [
      app: :okta_api,
      version: @version,
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:tesla, :hackney, :logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:tesla, "~> 1.3"},
      {:hackney, "~> 1.15"},
      {:jason, ">= 1.0.0"},
      {:plug, "~> 1.8", optional: true},
      {:mox, "~> 0.5", only: :test}
    ]
  end

  defp package do
    [
      name: "okta_api",
      description: "Elixir SDK for Okta APIs",
      # These are the default files included in the package
      files: ~w(lib config .formatter.exs mix.exs README* LICENSE* ),
      licenses: ["MIT"],
        links: %{
          "GitHub" => @source_url
        }
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: @version,
      formatters: ["html"]
    ]
  end
end
