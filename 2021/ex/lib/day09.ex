defmodule Day09 do
  def part_1(file) do
    grid = get_input(file)
    rows = length(grid)
    cols = length(hd(grid))

    for row <- 0..(rows - 1),
        col <- 0..(cols - 1),
        is_low_point?(grid, row, col) do
      {row, col, get_value(grid, row, col)}
    end
    |> Enum.map(fn {_, _, v} -> v + 1 end)
    |> Enum.sum()
  end

  def part_2(file) do
    grid = get_input(file)
    rows = length(grid)
    cols = length(hd(grid))

    for row <- 0..(rows - 1),
        col <- 0..(cols - 1),
        is_low_point?(grid, row, col) do
      {row, col, get_value(grid, row, col)}
    end
    |> Enum.map(fn {r, c, _} ->
      travel(grid, r, c) |> MapSet.size()
    end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def travel(grid, start_row, start_col) do
    travel(grid, start_row, start_col, MapSet.new())
  end

  defp travel(grid, row, col, visited) do
    cond do
      invalid_position?(grid, row, col) ->
        visited

      MapSet.member?(visited, {row, col}) ->
        visited

      get_value(grid, row, col) == 9 ->
        visited

      true ->
        current_value = get_value(grid, row, col)
        updated_visited = MapSet.put(visited, {row, col})
        neighbors = get_valid_neighbors(grid, row, col, current_value, updated_visited)

        Enum.reduce(neighbors, updated_visited, fn {next_row, next_col}, acc_visited ->
          travel(grid, next_row, next_col, acc_visited)
        end)
    end
  end

  defp get_valid_neighbors(grid, row, col, current_value, visited) do
    [
      # up
      {row - 1, col},
      # down
      {row + 1, col},
      # left
      {row, col - 1},
      # right
      {row, col + 1}
    ]
    |> Enum.reject(fn {r, c} ->
      neighbor_value = get_value(grid, r, c)

      invalid_position?(grid, r, c) ||
        MapSet.member?(visited, {r, c}) ||
        neighbor_value <= current_value ||
        neighbor_value == 9
    end)
  end

  defp invalid_position?(grid, row, col) do
    row < 0 ||
      col < 0 ||
      row >= length(grid) ||
      col >= length(hd(grid))
  end

  defp is_low_point?(grid, row, col) do
    current = get_value(grid, row, col)

    neighbors = [
      {row - 1, col},
      {row + 1, col},
      {row, col - 1},
      {row, col + 1}
    ]

    Enum.all?(neighbors, fn {r, c} ->
      neighbor_value = get_value(grid, r, c)
      neighbor_value == :invalid || current < neighbor_value
    end)
  end

  defp get_value(grid, row, col) do
    cond do
      row < 0 || row >= length(grid) -> :invalid
      col < 0 || col >= length(hd(grid)) -> :invalid
      true -> grid |> Enum.at(row) |> Enum.at(col)
    end
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn line ->
      String.graphemes(line)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
