defmodule Day16 do
  def part_1(file) do
    grid =
      get_input(file)
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {c, x} ->
          {c, x, y, :infinity}
        end)
      end)

    {_, x, y, _} =
      grid
      |> List.flatten()
      |> Enum.find(fn
        {"S", _, _, _} -> true
        _ -> false
      end)

    heap = Heap.new() |> Heap.push({0, {x, y, :right}})

    travel(grid, heap)
    |> IO.inspect()
  end

  def part_2(file) do
    grid =
      get_input(file)
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {c, x} ->
          {c, x, y, :infinity}
        end)
      end)

    {_, x, y, _} =
      grid
      |> List.flatten()
      |> Enum.find(fn
        {"S", _, _, _} -> true
        _ -> false
      end)

    heap = Heap.new() |> Heap.push({0, {x, y, :right, []}})

    travel_2(grid, heap, [])
    |> Enum.map(fn {_, path} -> path end)
    |> List.flatten()
    |> Enum.uniq()
    |> length()
    |> IO.inspect()
  end

  defp travel_2(grid, heap, found_paths) do
    if Heap.empty?(heap) do
      found_paths
    else
      {score, {x, y, dir, visited}} = Heap.root(heap)
      heap = Heap.pop(heap)
      {c, _, _, elem_score} = get_elem(grid, {x, y})

      cond do
        c == "E" ->
          with [{best_score, _} | _] <- found_paths,
               true <- score > best_score do
            travel_2(grid, heap, found_paths)
          else
            _ -> travel_2(grid, heap, [{score, [{x, y}] ++ visited}] ++ found_paths)
          end

        c == "#" ->
          travel_2(grid, heap, found_paths)

        score > elem_score and score - 1000 != elem_score ->
          travel_2(grid, heap, found_paths)

        true ->
          explore_2(grid, heap, {x, y, dir, score}, [{x, y}] ++ visited, found_paths)
      end
    end
  end

  defp explore_2(grid, heap, {x, y, dir, score}, visited, found_paths) do
    grid = update_score(grid, {x, y}, score)

    heap =
      get_next({x, y, dir})
      |> Enum.reduce(heap, fn {nx, ny, ndir, add}, acc ->
        Heap.push(acc, {score + add, {nx, ny, ndir, visited}})
      end)

    travel_2(grid, heap, found_paths)
  end

  defp travel(grid, heap) do
    if Heap.empty?(heap) do
      0
    else
      {score, {x, y, dir}} = Heap.root(heap)
      heap = Heap.pop(heap)
      {c, _, _, elem_score} = get_elem(grid, {x, y})

      cond do
        c == "E" ->
          score

        c == "#" ->
          travel(grid, heap)

        score >= elem_score ->
          travel(grid, heap)

        true ->
          explore(grid, heap, {x, y, dir, score})
      end
    end
  end

  defp explore(grid, heap, {x, y, dir, score}) do
    grid = update_score(grid, {x, y}, score)

    heap =
      get_next({x, y, dir})
      |> Enum.reduce(heap, fn {nx, ny, ndir, add}, acc ->
        Heap.push(acc, {score + add, {nx, ny, ndir}})
      end)

    travel(grid, heap)
  end

  defp update_score(grid, {x, y}, score) do
    List.update_at(grid, y, fn row ->
      List.update_at(row, x, fn {c, x, y, _} -> {c, x, y, score} end)
    end)
  end

  defp get_elem(grid, {x, y}) do
    grid |> Enum.at(y) |> Enum.at(x)
  end

  defp get_next({x, y, direction}) do
    [{x - 1, y, :left}, {x + 1, y, :right}, {x, y + 1, :down}, {x, y - 1, :up}]
    |> Enum.reject(fn
      {_, _, :up} -> direction == :down
      {_, _, :right} -> direction == :left
      {_, _, :left} -> direction == :right
      {_, _, :down} -> direction == :up
      _ -> direction == :any
    end)
    |> Enum.map(fn
      {x, y, dir} when dir == direction or direction == :any -> {x, y, dir, 1}
      {x, y, new_dir} -> {x, y, new_dir, 1001}
    end)
  end

  def get_input(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
