defmodule ExtocatWeb.Controller do
  @moduledoc """
  A controller plug implementation for the Extocat Scoring Service.

  This module is invoked in response to HTTP requests. It is responsible for interfacing with the
  core `:extocat` application to gather all the necessary data and perform all the necessary steps
  before invoking the view layer to return a JSON response.
  """

  alias ExtocatWeb.View

  @behaviour Plug

  @impl Plug
  def call(conn, _opts), do: Plug.Conn.send_resp(conn, 200, Jason.encode!(View.render([])))

  @impl Plug
  def init([]), do: false
end
