defmodule ExtocatWeb.JSONAPI do
  @moduledoc """
  A plug implementation for JSON API.

  This module is invoked in response to HTTP requests. It is responsible for ensuring the response
  conforms to the JSON API (v1.0)
  [server specification](http://jsonapi.org/format/1.0/#content-negotiation-servers).
  """

  @behaviour Plug

  @type_name "application"
  @subtype_name "vnd.api+json"
  @content_type "#{@type_name}/#{@subtype_name}"

  import Plug.Conn

  @impl Plug
  def call(conn, _opts) do
    is_acceptable = valid_accept_header?(conn)
    is_media_type_supported = valid_content_type_header?(conn)

    cond do
      not is_acceptable and not is_media_type_supported -> halt_with_error(conn, 400)
      not is_acceptable -> halt_with_error(conn, 406)
      not is_media_type_supported -> halt_with_error(conn, 415)
      true -> put_resp_content_type(conn, @content_type, nil)
    end
  end

  @spec valid_accept_header?(Plug.Conn.t()) :: boolean
  defp valid_accept_header?(conn) do
    case get_req_header(conn, "accept") do
      [] ->
        true

      [string] ->
        string
        |> String.split(~r/\s*,\s*/)
        |> Stream.map(&Plug.Conn.Utils.media_type/1)
        |> Enum.any?(&valid_tagged_type?/1)
    end
  end

  @spec valid_tagged_type?(
          {:ok, String.t(), String.t(), %{optional(String.t()) => String.t()}}
          | :error
        ) :: boolean
  defp valid_tagged_type?({:ok, @type_name, @subtype_name, params}), do: params === %{}
  defp valid_tagged_type?({:ok, @type_name, "*", params}), do: params === %{}
  defp valid_tagged_type?({:ok, "*", "*", params}), do: params === %{}
  defp valid_tagged_type?(_), do: false

  @spec valid_content_type_header?(Plug.Conn.t()) :: boolean
  defp valid_content_type_header?(conn) do
    case get_req_header(conn, "content-type") do
      [] ->
        true

      [string] ->
        case Plug.Conn.Utils.content_type(string) do
          {:ok, @type_name, @subtype_name, params} -> params === %{}
          _ -> true
        end
    end
  end

  json_by_status = %{
    400 =>
      ~s({"errors":[) <>
        ~s({"status":"406","title":"Not Acceptable"},) <>
        ~s({"status":"415","title":"Unsupported Media Type"}]}),
    406 => ~s({"errors":[{"status":"406","title":"Not Acceptable"}]}),
    415 => ~s({"errors":[{"status":"415","title":"Unsupported Media Type"}]})
  }

  @spec halt_with_error(Plug.Conn.t(), integer) :: Plug.Conn.t()
  for {status, json} <- json_by_status do
    defp halt_with_error(conn, unquote(status)),
      do:
        conn
        |> put_resp_content_type(@content_type, nil)
        |> send_resp(unquote(status), unquote(json))
        |> halt()
  end

  @impl Plug
  def init([]), do: false
end
