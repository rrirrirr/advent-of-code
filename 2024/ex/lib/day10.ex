defmodule Day10 do
  def part_1(file) do
    grid = parse_grid_from_file(file)

    grid
    |> find_starting_points()
    |> Enum.map(&trace_paths_from_point(grid, &1, MapSet.new()))
    |> Enum.flat_map(&Enum.uniq/1)
    |> Enum.count()
    |> IO.inspect()
  end

  def part_2(file) do
    grid = parse_grid_from_file(file)

    grid
    |> find_starting_points()
    |> Enum.map(&trace_paths_from_point(grid, &1, MapSet.new()))
    |> List.flatten()
    |> Enum.count()
    |> IO.inspect()
  end

  defp trace_paths_from_point(grid, point, visited) do
    case get_height(grid, point) do
      9 ->
        [point]

      _ ->
        visited = MapSet.put(visited, point)

        find_valid_neighbors(grid, point, visited)
        |> Enum.flat_map(&trace_paths_from_point(grid, &1, visited))
    end
  end

  defp find_valid_neighbors(grid, {x, y}, visited) do
    current_height = get_height(grid, {x, y})
    grid_width = length(hd(grid))
    grid_height = length(grid)

    [
      {-1, 0},
      {1, 0},
      {0, -1},
      {0, 1}
    ]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.filter(fn {nx, ny} ->
      nx >= 0 and nx < grid_width and
        ny >= 0 and ny < grid_height
    end)
    |> Enum.reject(&MapSet.member?(visited, &1))
    |> Enum.filter(&(get_height(grid, &1) - current_height == 1))
  end

  defp get_height(grid, {x, y}) do
    grid |> Enum.at(y) |> Enum.at(x)
  end

  defp find_starting_points(grid) do
    grid
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {v, x} ->
        {v, {x, y}}
      end)
      |> Enum.filter(fn
        {0, _} -> true
        _ -> false
      end)
    end)
    |> Enum.map(fn {_, coords} -> coords end)
  end

  defp parse_grid_from_file(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.graphemes(row)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
