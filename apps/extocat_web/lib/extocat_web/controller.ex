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
  def call(conn, _opts) do
    username = conn_to_username(conn)

    case Extocat.fetch_score(username) do
      {:ok, score} ->
        Plug.Conn.send_resp(
          conn,
          200,
          Jason.encode!(View.render(score: score, username: username))
        )

      {:error, :not_found} ->
        Plug.Conn.send_resp(conn, 404, ~s({"errors":[{"status":"404","title":"Not Found"}]}))

      {:error, :timeout} ->
        Plug.Conn.send_resp(conn, 502, ~s({"errors":[{"status":"502","title":"Bad Gateway"}]}))
    end
  end

  @spec conn_to_username(Plug.Conn.t()) :: String.t()
  defp conn_to_username(%{path_info: []}), do: ""
  defp conn_to_username(%{path_info: [username | _]}), do: username

  @impl Plug
  def init([]), do: false
end
