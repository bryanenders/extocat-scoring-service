defmodule ExtocatWeb.MixProject do
  use Mix.Project

  def application,
    do: [
      extra_applications: [:logger],
      mod: {ExtocatWeb.Application, []}
    ]

  def project,
    do: [
      app: :extocat_web,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps: deps(),
      deps_path: "../../deps",
      elixir: "~> 1.6",
      lockfile: "../../mix.lock",
      start_permanent: Mix.env() === :prod,
      test_paths: ["lib"],
      version: "0.1.0"
    ]

  defp deps,
    do: [
      {:cowboy, "~> 2.1"},
      {:extocat, in_umbrella: true},
      {:jason, "~> 1.0"},
      {:plug, "~> 1.5"}
    ]
end
