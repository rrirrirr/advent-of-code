defmodule Day17 do
  def part_1(file) do
    input = get_input(file)

    active =
      input
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        Enum.with_index(row) |> Enum.map(fn {c, x} -> {{x, y, 0}, c} end)
      end)
      |> List.flatten()
      |> Enum.filter(fn {_, c} -> c == "#" end)

    map =
      active
      |> Map.new()

    1..6
    |> Enum.reduce(map, fn _step, acc ->
      Map.keys(acc)
      |> Enum.flat_map(&get_neighbors_coords(&1))
      |> Enum.uniq()
      |> Enum.map(fn coords ->
        state = Map.get(acc, coords, ".")

        neighbors =
          get_neighbors_coords(coords)
          |> Enum.reject(&(&1 == coords))
          |> Enum.map(&Map.get(acc, &1, "."))

        {coords, switch_state(state, neighbors)}
      end)
      |> Enum.filter(fn {_, state} -> state == "#" end)
      |> Map.new()
    end)
    |> Kernel.map_size()
    |> IO.inspect()
  end

  def part_2(file) do
    input = get_input(file)

    active =
      input
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        Enum.with_index(row) |> Enum.map(fn {c, x} -> {{x, y, 0, 0}, c} end)
      end)
      |> List.flatten()
      |> Enum.filter(fn {_, c} -> c == "#" end)

    map =
      active
      |> Map.new()

    1..6
    |> Enum.reduce(map, fn _step, acc ->
      Map.keys(acc)
      |> Enum.flat_map(&get_neighbors_coords_4d(&1))
      |> Enum.uniq()
      |> Enum.map(fn coords ->
        state = Map.get(acc, coords, ".")

        neighbors =
          get_neighbors_coords_4d(coords)
          |> Enum.reject(&(&1 == coords))
          |> Enum.map(&Map.get(acc, &1, "."))

        {coords, switch_state(state, neighbors)}
      end)
      |> Enum.filter(fn {_, state} -> state == "#" end)
      |> Map.new()
    end)
    |> Kernel.map_size()
    |> IO.inspect()
  end

  defp switch_state("#", ns) do
    freqs = ns |> Enum.frequencies()

    case Map.get(freqs, "#") do
      2 -> "#"
      3 -> "#"
      _ -> "."
    end
  end

  defp switch_state(".", ns) do
    freqs = ns |> Enum.frequencies()

    case Map.get(freqs, "#") do
      3 -> "#"
      _ -> "."
    end
  end

  defp get_neighbors_coords({x, y, z}) do
    for dx <- -1..1,
        dy <- -1..1,
        dz <- -1..1 do
      {x + dx, y + dy, z + dz}
    end
  end

  defp get_neighbors_coords_4d({x, y, z, w}) do
    for dx <- -1..1,
        dy <- -1..1,
        dz <- -1..1,
        dw <- -1..1 do
      {x + dx, y + dy, z + dz, w + dw}
    end
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
