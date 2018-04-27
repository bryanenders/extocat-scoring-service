use Mix.Config

import_config "../apps/*/config/config.exs"

if Mix.env() === :dev do
  config :mix_test_watch, tasks: ["test", "credo", "dialyzer"]
end
