defmodule Help.Game.Point do
  def new(x, y) when is_integer(x) and is_integer(y), do: {x, y}
  def move({x, y}, {by_x, by_y}), do: {x + by_x, y + by_y}
  def transpose({x, y}), do: {y, x}
  def flip({x, y}), do: {x, 6 - y}
  def reflect({x, y}), do: {6 - x, y}

  def rotate(point, 0), do: point
  def rotate(point, 90), do: point |> reflect() |> transpose()
  def rotate(point, 180), do: point |> flip() |> reflect()
  def rotate(point, 270), do: point |> flip() |> transpose()

  def center(point), do: move(point, {-3, -3})

  # [{3, 2}, {4,2}, {3, 3}, {4, 3}, {3, 4}] |> Enum.map(&P.rotate(&1, 90)) |> Enum.map(&P.reflect/1) |> Enum.map(&P.move(&1, {5,5})) |> Enum.map(&P.center/1)
  # [{6, 5}, {6, 4}, {5, 5}, {5, 4}, {4, 5}]

  def prepare(point, rotation, reflected, location) do
    point
    |> rotate(rotation)
    |> maybe_reflect(reflected)
    |> move(location)
    |> center()
  end

  defp maybe_reflect(point, true), do: reflect(point)
  defp maybe_reflect(point, false), do: point
end
