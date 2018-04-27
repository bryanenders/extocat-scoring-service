defmodule GitHub do
  @moduledoc """
  This module provides functions for reading and writing GitHub data.
  """

  @type username :: binary

  alias GitHub.{Adapter, DefaultAdapter}

  @doc """
  Returns a specification to start this module under a supervisor.
  """
  @spec child_spec(Adapter.t() | nil) :: Supervisor.child_spec()
  def child_spec(adapter), do: %{id: __MODULE__, start: {__MODULE__, :start_link, [adapter]}}

  @doc """
  Fetches the events for the `username` and returns it in a tuple.

  If the user does not exist, returns `{:error, :not_found}`. If a timely response is not
  received, returns `{:error, :timeout}`.
  """
  @spec fetch_events(username) :: {:ok, [GitHub.Event.t()]} | {:error, :not_found | :timeout}
  def fetch_events(username), do: Agent.get(__MODULE__, & &1).fetch_events(username)

  @doc """
  Starts the `GitHub` process linked to the current process.

  This is often used to start the process as part of a supervision tree.
  """
  @spec start_link(Adapter.t() | nil) :: {:ok, pid} | {:error, {:already_started, pid}}
  def start_link(adapter),
    do: Agent.start_link(fn -> adapter || DefaultAdapter end, name: __MODULE__)
end
