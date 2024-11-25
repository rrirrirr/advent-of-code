defmodule Day19 do
  def part_2(file) do
    scanner_data = get_input(file)
    scanner_0 = hd(scanner_data)

    scanner_orientations =
      scanner_data |> Enum.drop(1) |> find_orientations() |> Enum.with_index()

    {positions, _} =
      Enum.reduce_while(1..2000, {[{0, 0, 0}], {scanner_0, scanner_orientations}}, fn _,
                                                                                      {positions,
                                                                                       {ref,
                                                                                        scanners_left}} ->
        IO.inspect(length(scanners_left))

        case scanners_left do
          [] ->
            {:halt, {positions, ref}}

          _ ->
            {_orientation, aligned_beacons, index, offset} =
              Enum.find_value(scanners_left, fn {orientation, idx} ->
                case find_overlaps(ref, orientation) do
                  nil -> nil
                  {offset, beacons} -> {orientation, beacons, idx, offset}
                end
              end)

            remaining_scanners = Enum.reject(scanners_left, fn {_, idx} -> idx == index end)
            {:cont, {[offset | positions], {ref ++ aligned_beacons, remaining_scanners}}}
        end
      end)

    for p1 <- positions, p2 <- positions do
      manhattan_distance(p1, p2)
    end
    |> Enum.max()
  end

  def part_1(file) do
    scanner_data = get_input(file)
    scanner_0 = hd(scanner_data)

    scanner_orientations =
      scanner_data |> Enum.drop(1) |> find_orientations() |> Enum.with_index()

    Enum.reduce_while(1..2000, {scanner_0, scanner_orientations}, fn _, {ref, scanners_left} ->
      IO.inspect(length(scanners_left))

      case scanners_left do
        [] ->
          {:halt, ref}

        _ ->
          {_orientation, aligned_beacons, index} =
            Enum.find_value(scanners_left, fn {orientation, idx} ->
              case find_overlaps(ref, orientation) do
                nil -> nil
                {_offset, beacons} -> {orientation, beacons, idx}
              end
            end)

          remaining_scanners = Enum.reject(scanners_left, fn {_, idx} -> idx == index end)
          {:cont, {ref ++ aligned_beacons, remaining_scanners}}
      end
    end)
    |> Enum.count()
  end

  defp manhattan_distance({x1, y1, z1}, {x2, y2, z2}) do
    abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
  end

  defp find_overlaps(reference, orientations) do
    Enum.find_value(orientations, fn orientation ->
      Enum.find_value(reference, fn ref_beacon ->
        Enum.find_value(orientation, fn test_beacon ->
          offset = point_diff(ref_beacon, test_beacon)

          aligned_beacons =
            Enum.map(orientation, fn beacon ->
              point_add(beacon, offset)
            end)

          non_overlaps = aligned_beacons -- reference
          matches = Enum.count(aligned_beacons, &Enum.member?(reference, &1))

          if matches >= 12 do
            {offset, non_overlaps}
          end
        end)
      end)
    end)
  end

  defp point_diff({x1, y1, z1}, {x2, y2, z2}) do
    {x1 - x2, y1 - y2, z1 - z2}
  end

  defp point_add({x1, y1, z1}, {x2, y2, z2}) do
    {x1 + x2, y1 + y2, z1 + z2}
  end

  defp find_orientations(scanners) do
    Enum.map(scanners, fn scanner_points ->
      Enum.map(scanner_points, &get_all_orientations/1)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
    end)
  end

  defp get_all_orientations({x, y, z}) do
    [
      # Facing +x
      {x, y, z},
      {x, -z, y},
      {x, -y, -z},
      {x, z, -y},
      # Facing -x
      {-x, -y, z},
      {-x, -z, -y},
      {-x, y, -z},
      {-x, z, y},
      # Facing +y
      {y, -x, z},
      {y, -z, -x},
      {y, x, -z},
      {y, z, x},
      # Facing -y
      {-y, x, z},
      {-y, -z, x},
      {-y, -x, -z},
      {-y, z, -x},
      # Facing +z
      {z, y, -x},
      {z, x, y},
      {z, -y, x},
      {z, -x, -y},
      # Facing -z
      {-z, y, x},
      {-z, -x, y},
      {-z, -y, -x},
      {-z, x, -y}
    ]
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n\n")
    |> Enum.map(fn scanner ->
      String.split(scanner, "\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.drop(1)
      |> Enum.flat_map(&String.split(&1, ","))
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(3)
      |> Enum.map(fn [a, b, c] -> {a, b, c} end)
    end)
  end
end
