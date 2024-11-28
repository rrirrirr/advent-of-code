defmodule Day22 do
  def part_1(file) do
    get_input(file)
    |> Enum.reduce(MapSet.new(), fn {action, ranges}, acc ->
      cubes = build_cubes(ranges)

      case action do
        "on" -> MapSet.union(acc, MapSet.new(cubes))
        "off" -> MapSet.difference(acc, MapSet.new(cubes))
      end
    end)
    |> MapSet.size()
  end

  def part_2(file) do
    file
    |> get_input()
    |> Enum.map(fn {action, coords} -> {action, to_cube(coords)} end)
    |> Enum.reverse()
    |> sum_volumes()
  end

  defp sum_volumes(instructions), do: sum_volumes(instructions, {[], 0})

  defp sum_volumes([], {_, total}), do: total

  defp sum_volumes([{action, cube} | rest], {processed_cubes, total}) do
    intersections =
      processed_cubes
      |> Enum.map(&cube_intersection(&1, cube))
      |> Enum.reject(&is_nil/1)
      |> Enum.map(&{"on", &1})

    new_total =
      case action do
        "on" ->
          cube_volume = volume(cube)
          intersection_volume = sum_volumes(intersections, {[], 0})
          total + cube_volume - intersection_volume

        "off" ->
          total
      end

    sum_volumes(rest, {[cube | processed_cubes], new_total})
  end

  defp to_cube([[x1, x2], [y1, y2], [z1, z2]]), do: {x1, x2, y1, y2, z1, z2}

  defp volume({x1, x2, y1, y2, z1, z2}), do: (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)

  defp cube_intersection({x1, x2, y1, y2, z1, z2}, {x3, x4, y3, y4, z3, z4}) do
    x_min = max(x1, x3)
    x_max = min(x2, x4)
    y_min = max(y1, y3)
    y_max = min(y2, y4)
    z_min = max(z1, z3)
    z_max = min(z2, z4)

    if x_min <= x_max && y_min <= y_max && z_min <= z_max do
      {x_min, x_max, y_min, y_max, z_min, z_max}
    end
  end

  defp build_cubes([[xs, xe], [ys, ye], [zs, ze]]) do
    cond do
      xs > 50 || xe < -50 || ys > 50 || ye < -50 || zs > 50 || ze < -50 ->
        []

      true ->
        for x <- max(-50, xs)..min(50, xe),
            y <- max(-50, ys)..min(50, ye),
            z <- max(-50, zs)..min(50, ze),
            do: {x, y, z}
    end
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn row ->
      row
      |> String.split([" ", "x=", "y=", "z=", "..", ","])
      |> Enum.reject(&(&1 == ""))
      |> then(fn [action | rest] ->
        coordinates =
          rest
          |> Enum.map(&String.to_integer/1)
          |> Enum.chunk_every(2)

        {action, coordinates}
      end)
    end)
  end
end
