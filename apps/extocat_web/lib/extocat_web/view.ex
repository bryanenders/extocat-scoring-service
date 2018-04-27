defmodule ExtocatWeb.View do
  @moduledoc """
  The view layer of the Extocat Scoring Service.

  This module is responsible for rendering scorecards.
  """

  @type assigns :: keyword | %{optional(atom) => term}

  @doc """
  Renders the scorecard based on the `assigns`.

  Returns JSON-encodable data.

  ## Examples

      iex> View.render(score: 70, username: "josevalim")
      %{data: %{id: "josevalim", score: 70, type: "scorecards"}}

      iex> View.render(%{score: 42, username: "joearmstrong"})
      %{data: %{id: "joearmstrong", score: 42, type: "scorecards"}}

  """
  @spec render(assigns) :: %{data: map}
  def render(assigns) do
    assigns_map = Enum.into(assigns, %{})
    %{data: %{id: assigns_map[:username], score: assigns_map[:score], type: "scorecards"}}
  end
end
