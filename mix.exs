defmodule ConfexCached.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :confex_cached,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [source_ref: "v#\{@version\}", main: "readme", extras: ["README.md"]],
      package: package(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ConfexCached, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.16.0", only: :dev, runtime: false},
      {:excoveralls, ">= 0.7.0", only: [:dev, :test]},
      {:confex, "~> 3.0"}
    ]
  end

  defp package do
    [
      maintainers: ["Goran Pedić"],
      licenses: ["LICENSE"],
      links: %{github: "https://github.com/gpedic/confex_cached"},
      files: ~w(lib LICENSE mix.exs README.md)
    ]
  end
end
