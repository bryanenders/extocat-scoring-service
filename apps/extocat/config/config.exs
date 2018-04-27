use Mix.Config

if Mix.env() === :test do
  config :extocat, git_hub_adapter: GitHub.TestAdapter
end
