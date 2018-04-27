defmodule ExtocatWeb.View do
  @moduledoc """
  The view layer of the Extocat Scoring Service.

  This module is responsible for rendering scorecards.
  """

  @type assigns :: keyword | %{optional(atom) => term}

  @doc """
  Renders the scorecard based on the `assigns`.

  Returns JSON-encodable data.
  """
  @spec render(assigns) :: %{data: map}
  def render(_assigns), do: %{data: %{}}
end
