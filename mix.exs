defmodule ExtocatUmbrella.MixProject do
  use Mix.Project

  def project,
    do: [
      apps_path: "apps",
      deps: deps(),
      dialyzer: [
        flags: [
          :error_handling,
          :race_conditions,
          :underspecs,
          :unknown,
          :unmatched_returns
        ],
        ignore_warnings: ".dialyzer_ignore"
      ],
      start_permanent: Mix.env() === :prod
    ]

  defp deps,
    do: [
      {:credo, "~> 0.9.2", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 0.6", only: :dev, runtime: false}
    ]
end
