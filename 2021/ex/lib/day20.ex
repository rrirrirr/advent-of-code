defmodule Day20 do
  def part_1(file) do
    {algo, grid} = get_input(file)

    map =
      algo
      |> Enum.with_index()
      |> Enum.into(%{}, fn {c, idx} ->
        {idx, c}
      end)

    Enum.reduce(0..1, grid, fn step, current_grid ->
      current_length = length(current_grid) |> Kernel.+(2)

      grow_grid(current_grid, step)
      |> Enum.map(&Enum.chunk_every(&1, 3, 1, :discard))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.flat_map(&Enum.chunk_every(&1, 3, 1, :discard))
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.map(&get_binary/1)
      |> Enum.map(&Map.get(map, &1))
      |> Enum.chunk_every(current_length)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list(&1))
    end)
    |> List.flatten()
    |> Enum.count(&(&1 != "."))
  end

  def part_2(file) do
    {algo, grid} = get_input(file)

    map =
      algo
      |> Enum.with_index()
      |> Enum.into(%{}, fn {c, idx} ->
        {idx, c}
      end)

    Enum.reduce(0..49, grid, fn step, current_grid ->
      current_length = length(current_grid) |> Kernel.+(2)

      grow_grid(current_grid, step)
      |> Enum.map(&Enum.chunk_every(&1, 3, 1, :discard))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.flat_map(&Enum.chunk_every(&1, 3, 1, :discard))
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.map(&get_binary/1)
      |> Enum.map(&Map.get(map, &1))
      |> Enum.chunk_every(current_length)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list(&1))
    end)
    |> List.flatten()
    |> Enum.count(&(&1 != "."))
  end

  defp get_binary(string) do
    String.graphemes(string)
    |> Enum.map(
      &case &1 do
        "." -> "0"
        "#" -> "1"
      end
    )
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp grow_grid(grid, step) do
    default = if rem(step, 2) == 1, do: "#", else: "."
    increased_rows = grid |> Enum.map(&([default, default] ++ &1 ++ [default, default]))
    empty_row = hd(increased_rows) |> Enum.map(fn _ -> default end)
    [empty_row, empty_row] ++ increased_rows ++ [empty_row, empty_row]
  end

  defp get_input(file) do
    [algo, image] = File.read!(file) |> String.split("\n\n")

    {
      algo |> String.graphemes(),
      image |> String.split("\n") |> Enum.filter(&(&1 != "")) |> Enum.map(&String.graphemes/1)
    }
  end
end
