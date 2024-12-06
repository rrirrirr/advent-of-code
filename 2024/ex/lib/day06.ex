defmodule Day06 do
  def part_1(file) do
    grid = get_input(file)

    {x, y} =
      find_start_pos(grid)

    travel(grid, {x, y, "up"}, MapSet.new())
    |> MapSet.size()
    |> IO.inspect()
  end

  def part_2(file) do
    grid = get_input(file)

    {x_start, y_start} =
      find_start_pos(grid)

    travel(grid, {x_start, y_start, "up"}, MapSet.new())
    |> MapSet.to_list()
    |> Enum.drop(1)
    |> Task.async_stream(
      fn {x, y} ->
        grid
        |> List.update_at(y, fn row ->
          List.update_at(row, x, fn _ -> "#" end)
        end)
        |> look_for_loop({x_start, y_start, "up"}, MapSet.new())
      end,
      max_concurrency: System.schedulers_online()
    )
    |> Stream.filter(fn {:ok, result} -> result end)
    |> Enum.count()
    |> IO.inspect()
  end

  defp look_for_loop(grid, {x, y, _}, _)
       when x < 0 or y < 0 or x >= length(grid) or y >= length(hd(grid)),
       do: false

  defp look_for_loop(grid, pos = {x, y, dir}, visited) do
    cond do
      MapSet.member?(visited, pos) ->
        true

      get_tile(grid, {x, y}) == "#" ->
        look_for_loop(grid, turn({x, y, dir}), MapSet.put(visited, pos))

      true ->
        look_for_loop(grid, step({x, y, dir}), MapSet.put(visited, pos))
    end
  end

  defp travel(grid, {x, y, _}, visited)
       when x < 0 or y < 0 or x >= length(grid) or y >= length(hd(grid)),
       do: visited

  defp travel(grid, {x, y, dir}, visited) do
    case get_tile(grid, {x, y}) do
      "#" ->
        travel(grid, turn({x, y, dir}), visited)

      _ ->
        travel(grid, step({x, y, dir}), MapSet.put(visited, {x, y}))
    end
  end

  defp step({x, y, "up"}), do: {x, y - 1, "up"}
  defp step({x, y, "right"}), do: {x + 1, y, "right"}
  defp step({x, y, "down"}), do: {x, y + 1, "down"}
  defp step({x, y, "left"}), do: {x - 1, y, "left"}

  defp turn({x, y, "up"}), do: {x, y + 1, "right"}
  defp turn({x, y, "right"}), do: {x - 1, y, "down"}
  defp turn({x, y, "down"}), do: {x, y - 1, "left"}
  defp turn({x, y, "left"}), do: {x + 1, y, "up"}

  defp get_tile(grid, {x, y}) do
    Enum.at(grid, y) |> Enum.at(x)
  end

  defp find_start_pos(grid) do
    width = length(hd(grid))

    grid
    |> List.flatten()
    |> Enum.find_index(&(&1 == "^"))
    |> then(&{rem(&1, width), div(&1, width)})
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
