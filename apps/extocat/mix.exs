defmodule Extocat.MixProject do
  use Mix.Project

  def application,
    do: [
      extra_applications: [:logger]
    ]

  def project,
    do: [
      app: :extocat,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      elixir: "~> 1.6",
      lockfile: "../../mix.lock",
      start_permanent: Mix.env() === :prod,
      test_paths: ["lib"],
      version: "0.1.0"
    ]
end
