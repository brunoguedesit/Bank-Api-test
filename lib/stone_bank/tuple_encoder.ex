defmodule StoneBank.TupleEncoder do
  @moduledoc """
   Tuple encoder for our type of amount
  """

  alias Jason.Encoder

  defimpl Encoder, for: Tuple do
    def encode(data, options) when is_tuple(data) do
      data
      |> Tuple.to_list()
      |> Encoder.List.encode(options)
    end
  end
end
