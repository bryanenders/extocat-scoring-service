defmodule Extocat.Application do
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args),
    do:
      Supervisor.start_link(
        [{GitHub, Application.get_env(:extocat, :git_hub_adapter)}],
        name: Extocat.Supervisor,
        strategy: :one_for_one
      )
end
