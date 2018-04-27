defmodule ExtocatWeb do
  @moduledoc """
  A plug pipeline for the Extocat Scoring Service.

  Each HTTP request begins and ends its lifecycle inside this module.
  """

  use Plug.Builder

  if Application.get_env(:extocat_web, :debug_errors) do
    use Plug.Debugger, otp_app: :extocat_web
  end

  alias ExtocatWeb.{Controller, JSONAPI}

  plug(Plug.Logger)

  if Application.get_env(:extocat_web, :force_ssl) do
    plug(Plug.SSL)
  end

  plug(JSONAPI)
  plug(Controller)
end
