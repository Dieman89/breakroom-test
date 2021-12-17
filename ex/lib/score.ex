defmodule Ex.Score do
  @moduledoc false
  @type t :: %__MODULE__{
          points: non_neg_integer(),
          total: non_neg_integer()
        }
  defstruct points: 0, total: 0
end
