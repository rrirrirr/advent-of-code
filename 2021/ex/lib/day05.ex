defmodule Day05 do
  def part_1(file) do
    input = get_input(file)

    input
    |> Enum.filter(&remove_diagonal_lines?/1)
    |> Enum.map(&get_range_between/1)
    |> List.flatten()
    |> get_coord_frequencies()
    |> Enum.count(fn {_coord, count} -> count > 1 end)
  end

  def part_2(file) do
    input = get_input(file)

    input
    |> Enum.map(&get_range_between/1)
    |> List.flatten()
    |> get_coord_frequencies()
    |> Enum.count(fn {_coord, count} -> count > 1 end)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n", " -> ", ","], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [x, y] -> {x, y} end)
    |> Enum.chunk_every(2)
  end

  defp remove_diagonal_lines?([{x1, y1}, {x2, y2}]) do
    x1 == x2 or y1 == y2
  end

  defp get_range_between([{x1, y1}, {x2, y2}]) when x1 == x2 or y1 == y2 do
    x_step = if x1 <= x2, do: 1, else: -1
    y_step = if y1 <= y2, do: 1, else: -1

    for x <- x1..x2//x_step,
        y <- y1..y2//y_step,
        do: {x, y}
  end

  defp get_range_between([{x1, y1}, {x2, y2}]) do
    x_step = if x1 <= x2, do: 1, else: -1
    y_step = if y1 <= y2, do: 1, else: -1
    x_range = Enum.to_list(x1..x2//x_step)
    y_range = Enum.to_list(y1..y2//y_step)
    Enum.zip(x_range, y_range)
  end

  defp get_coord_frequencies(list) do
    list |> Enum.frequencies()
  end
end
