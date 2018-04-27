defmodule GitHub.Event do
  @moduledoc """
  An Event struct.
  """

  @type t :: %__MODULE__{
          is_public: boolean,
          payload: %{optional(binary) => term},
          type: String.t()
        }

  @enforce_keys [:type]
  defstruct @enforce_keys ++ [is_public: true, payload: %{}]
end
