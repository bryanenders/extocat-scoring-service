defmodule Extocat.Score do
  @moduledoc """
  This module contains functions for working with scores.

  A Score is a non-negative integer.
  """

  @type t :: non_neg_integer

  @doc """
  Returns the cumulative score of a list of GitHub `events`.

  ## Examples

      iex> Score.from_events([%GitHub.Event{type: "PushEvent"}])
      5

      iex> Score.from_events([%GitHub.Event{type: "PullRequestReviewCommentEvent"}])
      4

      iex> Score.from_events([%GitHub.Event{type: "WatchEvent"}])
      3

      iex> Score.from_events([%GitHub.Event{type: "CreateEvent"}])
      2

      iex> Score.from_events([%GitHub.Event{type: "SomeNewEvent"}])
      1

      iex> Score.from_events([%GitHub.Event{type: "PushEvent"}, %GitHub.Event{type: "PushEvent"}])
      10

  """
  @spec from_events([GitHub.Event.t()]) :: t
  def from_events(events),
    do:
      events
      |> Stream.map(&event_to_score/1)
      |> Enum.sum()

  score_by_event = %{
    "PushEvent" => 5,
    "PullRequestReviewCommentEvent" => 4,
    "WatchEvent" => 3,
    "CreateEvent" => 2
  }

  @spec event_to_score(GitHub.Event.t()) :: t
  for {event, score} <- score_by_event do
    defp event_to_score(%GitHub.Event{type: unquote(event)}), do: unquote(score)
  end

  defp event_to_score(%GitHub.Event{}), do: 1
end
