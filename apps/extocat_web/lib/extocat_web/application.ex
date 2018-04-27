defmodule ExtocatWeb.Application do
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args),
    do:
      Supervisor.start_link(
        [
          {Plug.Adapters.Cowboy2,
           options: [port: Application.get_env(:extocat_web, :port)],
           plug: ExtocatWeb,
           scheme: Application.get_env(:extocat_web, :scheme)}
        ],
        name: ExtocatWeb.Supervisor,
        strategy: :one_for_one
      )
end
