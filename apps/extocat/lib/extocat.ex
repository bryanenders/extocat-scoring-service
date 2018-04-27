defmodule Extocat do
  @moduledoc """
  This module provides functions for interacting with the Extocat application as a black box.
  """

  alias Extocat.Score

  @doc """
  Fetches the score for the `username` and returns it in a tuple.

  If the user does not exist, returns `{:error, :not_found}`. If a timely response is not
  received, returns `{:error, :timeout}`.
  """
  @spec fetch_score(GitHub.username()) :: {:ok, Score.t()} | {:error, :not_found | :timeout}
  def fetch_score(username) when is_binary(username) do
    with {:ok, events} <- GitHub.fetch_events(username), do: {:ok, Score.from_events(events)}
  end
end
