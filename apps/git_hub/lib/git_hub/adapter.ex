defmodule GitHub.Adapter do
  @moduledoc """
  This module defines the responsibilities for working directly with a GitHub data source.
  """

  @type t :: module

  @doc """
  Fetches the events for the `username` and returns it in a tuple.

  If the user does not exist, returns `{:error, :not_found}`. If a timely response is not
  received, returns `{:error, :timeout}`.
  """
  @callback fetch_events(GitHub.username()) ::
              {:ok, Enumerable.t()} | {:error, :not_found | :timeout}
end
