defmodule Day20 do
  def part_1(file) do
    grid =
      get_input(file)
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {c, x} -> {c, x, y, :infinity} end)
      end)

    start = List.flatten(grid) |> Enum.find(fn {c, _x, _y, _} -> c == "S" end)
    heap = Heap.min() |> Heap.push({0, start})

    {grid, score, {target_x, target_y}} =
      find_path_without_cheat(grid, heap)

    grid =
      grid
      |> Enum.map(fn row ->
        row
        |> Enum.map(fn
          {"E", x, y, s} ->
            {"E", x, y, s + 1, 0}

          {c, x, y, s} ->
            {c, x, y, s, manhattan_dist({x, y}, {target_x, target_y})}
        end)
      end)

    start = List.flatten(grid) |> Enum.find(fn {c, _x, _y, _, _} -> c == "S" end)
    heap = Heap.min() |> Heap.push({0, start})

    find_path_(grid, heap, score - 1, [], score, 3)
    |> Enum.sort_by(fn {_, _, s} -> s end, :asc)
    # |> Enum.into(%{}, fn {st, e, score} ->
    #   {{st, e}, score}
    # end)
    # |> Map.values()
    # |> Enum.frequencies()
    # |> Enum.sort(:asc)
    # |> Enum.map(fn {_, amnt} -> amnt end)
    # |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(file) do
    grid =
      get_input(file)
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {c, x} -> {c, x, y, :infinity} end)
      end)

    start = List.flatten(grid) |> Enum.find(fn {c, _x, _y, _} -> c == "S" end)
    heap = Heap.min() |> Heap.push({0, start})

    {grid, score, {target_x, target_y}} =
      find_path_without_cheat(grid, heap)

    grid =
      grid
      |> Enum.map(fn row ->
        row
        |> Enum.map(fn
          {"E", x, y, s} ->
            {"E", x, y, s + 1, 0}

          {c, x, y, s} ->
            {c, x, y, s, manhattan_dist({x, y}, {target_x, target_y})}
        end)
      end)

    start = List.flatten(grid) |> Enum.find(fn {c, _x, _y, _, _} -> c == "S" end)
    heap = Heap.min() |> Heap.push({0, start})

    find_path_(grid, heap, score - 100, [], score, 21)
    |> Enum.sort_by(fn {_, _, s} -> s end, :asc)
    |> Enum.into(%{}, fn {st, e, score} ->
      {{st, e}, score}
    end)
    |> Map.values()
    |> Enum.frequencies()
    |> Enum.sort(:asc)
    |> Enum.map(fn {_, amnt} -> amnt end)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp find_path_(grid, heap, max_score, found, non_cheat_score, cheat_length) do
    with false <- Heap.empty?(heap),
         {{score, {char, x, y, base_score, _mnhtn_dist}}, new_heap} <- Heap.split(heap) do
      IO.inspect(Heap.size(heap), label: "#{score} / #{max_score}")

      cond do
        score > base_score ->
          find_path_(grid, new_heap, max_score, found, non_cheat_score, cheat_length)

        char == "#" ->
          find_path_(grid, new_heap, max_score, found, non_cheat_score, cheat_length)

        true ->
          positions =
            find_possible_cheat_positions(grid, {x, y}, cheat_length)

          new_found =
            positions
            |> Enum.map(fn {fx, fy, l} ->
              dist = score_position(grid, {fx, fy}, score + l, max_score, non_cheat_score)

              {{x, y}, {fx, fy}, dist}
            end)
            |> Enum.filter(fn {_, _, dist} ->
              dist <= max_score
            end)

          updated_heap =
            explore_(grid, new_heap, {x, y}, score + 1)

          find_path_(
            grid,
            updated_heap,
            max_score,
            found ++ new_found,
            non_cheat_score,
            cheat_length
          )
      end
    else
      _ -> found
    end
  end

  defp explore_(grid, heap, {x, y}, new_score) do
    length = length(hd(grid))
    height = length(grid)

    get_neighbors({x, y}, length, height)
    |> Enum.map(&{new_score, get_cell(grid, &1)})
    |> Enum.reduce(heap, fn item, acc -> Heap.push(acc, item) end)
  end

  defp find_possible_cheat_positions(grid, {start_x, start_y}, cheat_length) do
    length = length(hd(grid))
    height = length(grid)

    for x <- -cheat_length..cheat_length,
        y <- -cheat_length..cheat_length,
        nx = start_x + x,
        ny = start_y + y,
        nx >= 0 and nx < length,
        ny >= 0 and ny < height,
        dist = manhattan_dist({nx, ny}, {start_x, start_y}) + 1,
        dist <= cheat_length,
        {c, _, _, _, _} = get_cell(grid, {nx, ny}),
        c != "#",
        do: {nx, ny, dist}
  end

  defp score_position(grid, {x, y}, score, max_score, non_cheat_score) do
    {_, _, _, base_score, _} = get_cell(grid, {x, y})

    cond do
      base_score == :infinity -> max_score + 1
      true -> non_cheat_score - base_score + score
    end
  end

  defp find_path_without_cheat(grid, heap) do
    with false <- Heap.empty?(heap),
         {{score, {char, x, y, _}}, new_heap} <- Heap.split(heap) do
      cond do
        char == "E" ->
          grid = update_grid(grid, {x, y}, {char, x, y, score})
          {grid, score, {x, y}}

        score > get_score(grid, {x, y}) ->
          find_path_without_cheat(grid, new_heap)

        char == "#" ->
          find_path_without_cheat(grid, new_heap)

        true ->
          {updated_grid, updated_heap} =
            explore_without_cheat(grid, new_heap, char, {x, y}, score + 1)

          find_path_without_cheat(updated_grid, updated_heap)
      end
    else
      _ -> :infinity
    end
  end

  defp explore_without_cheat(grid, heap, char, {x, y}, new_score) do
    grid = update_grid(grid, {x, y}, {char, x, y, new_score})
    length = length(hd(grid))
    height = length(grid)

    new_heap =
      get_neighbors({x, y}, length, height)
      |> Enum.map(&{new_score, get_cell(grid, &1)})
      |> Enum.reduce(heap, fn item, acc -> Heap.push(acc, item) end)

    {grid, new_heap}
  end

  defp get_cell(grid, {x, y}) do
    Enum.at(grid, y) |> Enum.at(x)
  end

  defp get_score(grid, {x, y}) do
    case Enum.at(grid, y) |> Enum.at(x) do
      {_, _, _, score} -> score
      _ -> :infinity
    end
  end

  defp get_neighbors({x, y}, length, height) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
    |> Enum.filter(fn {x, y} ->
      x >= 0 and x < length and y >= 0 and y < height
    end)
  end

  defp update_grid(grid, {x, y}, replacement) do
    List.update_at(grid, y, fn row ->
      List.replace_at(row, x, replacement)
    end)
  end

  defp manhattan_dist({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
