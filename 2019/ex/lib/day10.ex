defmodule Day10 do
  def part_1(file) do
    grid = get_input(file)

    asteroids =
      grid
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        Enum.with_index(row) |> Enum.map(fn {c, x} -> {{x, y}, c} end)
      end)
      |> List.flatten()
      |> Enum.filter(fn {_, s} -> s == "#" end)
      |> Enum.map(fn {coords, _} -> coords end)
      |> MapSet.new()

    visible =
      asteroids
      |> Enum.map(fn {x, y} ->
        other_asteroids =
          asteroids
          |> Enum.reject(fn {ox, oy} -> ox == x and oy == y end)

        visible_directions =
          other_asteroids
          |> Enum.map(fn {ox, oy} ->
            dx = ox - x
            dy = oy - y
            gcd = Integer.gcd(abs(dx), abs(dy))
            {div(dx, gcd), div(dy, gcd)}
          end)
          |> MapSet.new()

        {{x, y}, MapSet.size(visible_directions)}
      end)

    {best_position, count} = Enum.max_by(visible, fn {_, count} -> count end)
    IO.inspect(count)
    best_position
  end

  def part_2(file) do
    {bx, by} = part_1(file)
    grid = get_input(file)

    other_asteroids =
      grid
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        Enum.with_index(row) |> Enum.map(fn {c, x} -> {{x, y}, c} end)
      end)
      |> List.flatten()
      |> Enum.filter(fn {_, s} -> s == "#" end)
      |> Enum.map(fn {coords, _} -> coords end)
      |> Enum.reject(fn {ox, oy} -> ox == bx and oy == by end)
      |> MapSet.new()

    visible_directions =
      other_asteroids
      |> Enum.map(fn {ox, oy} ->
        dx = ox - bx
        dy = oy - by
        gcd = Integer.gcd(abs(dx), abs(dy))
        ndx = div(dx, gcd)
        ndy = div(dy, gcd)

        angle = :math.atan2(ndx, -ndy)

        angle = if angle < 0, do: angle + 2 * :math.pi(), else: angle

        # manhattan distance works
        distance = abs(ox - bx) + abs(oy - by)
        # distance = :math.sqrt((ox - bx) * (ox - bx) + (oy - by) * (oy - by))

        {{ox, oy}, {ndx, ndy}, angle, distance}
      end)

    map =
      visible_directions
      |> Enum.group_by(
        fn {_, dir, _, _} -> dir end,
        fn {pos, _, _, distance} -> {pos, distance} end
      )
      |> Map.new(fn {{ndx, ndy}, asteroids} ->
        sorted = Enum.sort_by(asteroids, fn {_, distance} -> distance end)
        {{ndx, ndy}, sorted}
      end)

    sorted_directions =
      visible_directions
      |> Enum.map(fn {_, dir, angle, _} -> {dir, angle} end)
      |> Enum.uniq()
      |> Enum.sort_by(fn {_, angle} -> angle end)
      |> Enum.map(fn {{ndx, ndy}, _} -> {ndx, ndy} end)

    1..200
    |> Enum.reduce({map, sorted_directions}, fn step, {map, directions_left} ->
      [current_dir | rest] = directions_left

      [closest | further] = Map.get(map, current_dir)
      map = Map.put(map, current_dir, further)

      cond do
        step == 200 ->
          closest

        length(further) == 0 ->
          {map, rest}

        true ->
          {map, rest ++ [closest]}
      end
    end)
    |> then(fn {{x, y}, _} -> x * 100 + y end)
    |> IO.inspect()
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
