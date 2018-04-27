defmodule GitHub.DefaultAdapter do
  @moduledoc """
  An `Adapter` implementation that utilizes the GitHub REST API v3.
  """

  alias GitHub.{Adapter, Event}

  @behaviour Adapter

  @impl Adapter
  def fetch_events(username) when is_binary(username) do
    url = "https://api.github.com/users/#{URI.encode_www_form(username)}/events/public"
    req_headers = [{"accept", "application/vnd.github.v3+json"}]

    case :hackney.get(url, req_headers) do
      {:ok, 404, _, _} ->
        {:error, :not_found}

      {:ok, 200, _, client} ->
        {:ok, body} = :hackney.body(client)

        events =
          body
          |> Jason.decode!()
          |> Stream.map(&map_to_event/1)

        {:ok, events}

      _ ->
        {:error, :timeout}
    end
  end

  @spec map_to_event(%{binary => term}) :: Event.t()
  defp map_to_event(map),
    do: %Event{
      payload: Map.fetch!(map, "payload"),
      is_public: Map.fetch!(map, "public"),
      type: Map.fetch!(map, "type")
    }
end
