defmodule Day18 do
  @size 71

  def part_1(file) do
    grid =
      1..(@size * @size)
      |> Enum.map(fn idx ->
        with idx <- idx - 1, do: {:empty, {rem(idx, @size), div(idx, @size)}, :infinity}
      end)
      |> Enum.chunk_every(@size)

    grid =
      get_input(file)
      |> Enum.take(1024)
      |> Enum.reduce(grid, fn {x, y}, acc ->
        update_grid(acc, {x, y}, {:blocked, {x, y}, :infinity})
      end)

    heap = Heap.min() |> Heap.push({0, {0, 0}})

    find_path(grid, heap)
    |> IO.inspect()
  end

  def part_2(file) do
    grid =
      1..(@size * @size)
      |> Enum.map(fn idx ->
        with idx <- idx - 1, do: {:empty, {rem(idx, @size), div(idx, @size)}, :infinity}
      end)
      |> Enum.chunk_every(@size)

    blocks = get_input(file)

    1024..length(blocks)
    |> Task.async_stream(
      fn n ->
        grid =
          blocks
          |> Enum.take(n)
          |> Enum.reduce(grid, fn {x, y}, acc ->
            update_grid(acc, {x, y}, {:blocked, {x, y}, :infinity})
          end)

        heap = Heap.min() |> Heap.push({0, {0, 0}})

        v = find_path(grid, heap)
        {n, v}
      end,
      ordered: true,
      max_concurrency: System.schedulers_online(),
      on_timeout: :exit
    )
    |> Enum.reduce_while(nil, fn
      {:ok, {n, 0}}, _ -> {:halt, Enum.at(blocks, n - 1)}
      _, acc -> {:cont, acc}
    end)
    |> then(fn {a, b} -> "#{a},#{b}" end)
    |> IO.inspect()
  end

  defp find_path(grid, heap) do
    with false <- Heap.empty?(heap),
         {{score, {x, y} = coords}, new_heap} <- Heap.split(heap) do
      cond do
        x == @size - 1 and y == @size - 1 ->
          score

        is_occupied(grid, coords) or score >= get_score(grid, coords) ->
          find_path(grid, new_heap)

        true ->
          # IO.inspect("#{x} #{y} #{score}")
          grid = update_grid(grid, coords, {:visited, coords, score})

          neighbors =
            get_neighbors(coords)
            |> Enum.map(&{score + 1, &1})
            |> Enum.reduce(new_heap, fn item, acc -> Heap.push(acc, item) end)

          find_path(grid, neighbors)
      end
    else
      _ -> 0
    end
  end

  defp is_occupied(grid, {x, y}) do
    case Enum.at(grid, y) |> Enum.at(x) do
      {:blocked, _, _} -> true
      {:visited, _, _} -> true
      _ -> false
    end
  end

  defp get_neighbors({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
    |> Enum.filter(fn {x, y} ->
      x >= 0 and x < @size and y >= 0 and y < @size
    end)
  end

  defp get_score(grid, {x, y}) do
    case Enum.at(grid, y) |> Enum.at(x) do
      {_, _, score} -> score
      _ -> :infinity
    end
  end

  defp update_grid(grid, {x, y}, replacement) do
    List.update_at(grid, y, fn row ->
      List.replace_at(row, x, replacement)
    end)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n", ","], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [a, b] -> {a, b} end)
  end
end
