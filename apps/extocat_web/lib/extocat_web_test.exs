defmodule ExtocatWebTest do
  use ExUnit.Case, async: true

  import Plug.{Conn, Test}

  @content_type "application/vnd.api+json"
  @opts ExtocatWeb.init([])

  defp accept_string(media_types), do: Enum.join(media_types, ", ")

  defp assert_response(conn, status) do
    assert [@content_type] === get_resp_header(conn, "content-type")
    assert :sent === conn.state
    assert status === conn.status
  end

  setup do: %{
          media_types: [
            "race/zygon",
            "race/*",
            "application/vnd.api+json; planet=mars",
            "application/*; planet=anura",
            "*/*; planet=skaro"
          ],
          request: conn(:get, "/david-tennant")
        }

  describe "JSON API error" do
    test "with invalid accept header", %{media_types: media_types, request: request} do
      conn =
        request
        |> put_req_header("accept", accept_string(media_types))
        |> ExtocatWeb.call(@opts)

      assert_response(conn, 406)
      assert ~s({"errors":[{"status":"406","title":"Not Acceptable"}]}) === conn.resp_body
    end

    test "with JSON API content-type header including params", %{request: request} do
      conn =
        request
        |> put_req_header("content-type", "application/vnd.api+json; planet=gallifrey")
        |> ExtocatWeb.call(@opts)

      assert_response(conn, 415)
      assert ~s({"errors":[{"status":"415","title":"Unsupported Media Type"}]}) === conn.resp_body
    end

    test "with invalid accept headers and JSON API content-type header including params", %{
      request: request
    } do
      conn =
        request
        |> put_req_header("accept", "race/sontaran")
        |> put_req_header("content-type", "application/vnd.api+json; planet=midnight")
        |> ExtocatWeb.call(@opts)

      assert_response(conn, 400)

      assert ~s({"errors":[{"status":"406","title":"Not Acceptable"},{"status":"415","title":"Unsupported Media Type"}]}) ===
               conn.resp_body
    end
  end

  describe "JSON API success" do
    test "without accept header", %{request: request} do
      request
      |> delete_req_header("accept")
      |> ExtocatWeb.call(@opts)
      |> assert_response(200)
    end

    test "with accept header containing JSON API media type", %{
      media_types: media_types,
      request: request
    } do
      request
      |> put_req_header("accept", accept_string(["application/vnd.api+json" | media_types]))
      |> ExtocatWeb.call(@opts)
      |> assert_response(200)
    end

    test "with accept header containing application type and wildcard subtype", %{
      media_types: media_types,
      request: request
    } do
      request
      |> put_req_header("accept", accept_string(["application/*" | media_types]))
      |> ExtocatWeb.call(@opts)
      |> assert_response(200)
    end

    test "with accept header containing wildcard type and wildcard subtype", %{
      media_types: media_types,
      request: request
    } do
      request
      |> put_req_header("accept", accept_string(["*/*" | media_types]))
      |> ExtocatWeb.call(@opts)
      |> assert_response(200)
    end

    test "without content-type header", %{request: request} do
      request
      |> delete_req_header("content-type")
      |> ExtocatWeb.call(@opts)
      |> assert_response(200)
    end

    test "with unknown content-type header", %{request: request} do
      request
      |> put_req_header("content-type", "race/dalek; planet=ood-sphere")
      |> ExtocatWeb.call(@opts)
      |> assert_response(200)
    end

    test "with JSON API content-type header", %{request: request} do
      request
      |> put_req_header("content-type", "application/vnd.api+json")
      |> ExtocatWeb.call(@opts)
      |> assert_response(200)
    end
  end

  test "unable to reach GitHub" do
    conn =
      :get
      |> conn("/timeout-lord")
      |> ExtocatWeb.call(@opts)

    assert_response(conn, 502)
    assert ~s({"errors":[{"status":"502","title":"Bad Gateway"}]}) === conn.resp_body
  end

  test "missing username" do
    conn =
      :get
      |> conn("/the-name-of-the-doctor")
      |> ExtocatWeb.call(@opts)

    assert_response(conn, 404)
    assert ~s({"errors":[{"status":"404","title":"Not Found"}]}) === conn.resp_body
  end

  test "existing username", %{request: request} do
    conn = ExtocatWeb.call(request, @opts)
    assert_response(conn, 200)
    assert ~s({"data":{"id":"david-tennant","score":5,"type":"scorecards"}}) === conn.resp_body
  end
end
