defmodule Help.Number do
  @moduledoc """
  CRC pattern
  Construct
  Reduce
  Convert
  """

  def base, do: Integer

  @doc """
  Constructor
  """
  @spec new(String.t()) :: integer()
  def new(string), do: Integer.parse(string) |> elem(0)

  @doc """
  Reducer
  """
  @spec add(integer, integer) :: integer
  def add(a, b), do: a + b

  @doc """
  Converter
  """
  @spec to_string(integer) :: String.t()
  def to_string(integer), do: Integer.to_string(integer)
end
