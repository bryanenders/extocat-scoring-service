defmodule GitHub.TestAdapter do
  @moduledoc """
  An `Adapter` implementation that returns stubbed data.
  """

  alias GitHub.{Adapter, Event}

  @behaviour Adapter

  @impl Adapter
  def fetch_events("timeout-lord"), do: {:error, :timeout}
  def fetch_events("the-name-of-the-doctor"), do: {:error, :not_found}
  def fetch_events("peter-cushing"), do: {:ok, []}
  def fetch_events("david-tennant"), do: {:ok, [%Event{type: "PushEvent"}]}
  def fetch_events("tom-baker"), do: {:ok, [%Event{type: "PullRequestReviewCommentEvent"}]}
  def fetch_events("peter-capaldi"), do: {:ok, [%Event{type: "WatchEvent"}]}
  def fetch_events("jon-pertwee"), do: {:ok, [%Event{type: "CreateEvent"}]}
  def fetch_events("matt-smith"), do: {:ok, [%Event{type: "GeronimoEvent"}]}

  def fetch_events("jodie-whittaker"),
    do:
      {:ok,
       [
         %Event{type: "PushEvent"},
         %Event{type: "WatchEvent"},
         %Event{type: "CreateEvent"},
         %Event{type: "PullRequestReviewCommentEvent"},
         %Event{type: "FantasticEvent"},
         %Event{type: "RunEvent"},
         %Event{type: "WatchEvent"},
         %Event{type: "CreateEvent"}
       ]}
end
