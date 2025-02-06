defmodule Day03 do
  def part_1(file) do
    [r1, r2] =
      get_input(file)
      |> Enum.map(fn p ->
        p
        |> Enum.reduce({{0, 0}, []}, fn {d, dist}, {{x, y}, acc} ->
          case d do
            "R" ->
              n = {x + dist, y}
              {n, [{{x, y}, n}] ++ acc}

            "U" ->
              n = {x, y + dist}
              {n, [{{x, y}, n}] ++ acc}

            "D" ->
              n = {x, y - dist}
              {n, [{{x, y}, n}] ++ acc}

            "L" ->
              n = {x - dist, y}
              {n, [{{x, y}, n}] ++ acc}
          end
        end)
        |> elem(1)
      end)

    r1
    |> Enum.flat_map(fn {{x1, y1}, {x2, y2}} ->
      r2
      |> Enum.map(fn {{xp1, yp1}, {xp2, yp2}} ->
        cond do
          x1 == x2 and yp1 == yp2 ->
            if xp1 < x1 and xp2 > x1 and yp1 <= max(y1, y2) and yp1 >= min(y1, y2) do
              {x1, yp1}
            else
              false
            end

          y1 == y2 and xp1 == xp2 ->
            if yp1 < y1 and yp2 > y1 and xp1 <= max(x1, x2) and xp1 >= min(x1, x2) do
              {xp1, y1}
            else
              false
            end

          true ->
            false
        end
      end)
    end)
    |> Enum.filter(&(&1 != false))
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.sort()
    |> hd()
    |> IO.inspect()
  end

  def part_2(file) do
    [r1, r2] =
      get_input(file)
      |> Enum.map(fn p ->
        {_, _, path} =
          p
          |> Enum.reduce({0, {0, 0}, []}, fn {d, dist}, {total_dist, {x, y}, acc} ->
            case d do
              "R" ->
                n = {x + dist, y}
                {total_dist + dist, n, [{d, total_dist, {x, y}, n}] ++ acc}

              "U" ->
                n = {x, y + dist}
                {total_dist + dist, n, [{d, total_dist, {x, y}, n}] ++ acc}

              "D" ->
                n = {x, y - dist}
                {total_dist + dist, n, [{d, total_dist, {x, y}, n}] ++ acc}

              "L" ->
                n = {x - dist, y}
                {total_dist + dist, n, [{d, total_dist, {x, y}, n}] ++ acc}
            end
          end)

        path |> Enum.reverse()
      end)

    r1
    |> Enum.flat_map(fn {dir1, dist1, {x1, y1}, {x2, y2}} ->
      r2
      |> Enum.map(fn {dir2, dist2, {xp1, yp1}, {xp2, yp2}} ->
        cond do
          x1 == x2 and yp1 == yp2 ->
            if xp1 < x1 and xp2 > x1 and yp1 <= max(y1, y2) and yp1 >= min(y1, y2) do
              IO.inspect("#{dist1}, #{dist2}")
              steps1 = dist1 + abs(if dir1 == "U", do: y1 - yp1, else: y2 - yp1)
              steps2 = dist2 + abs(if dir2 == "L", do: x1 - xp1, else: x2 - xp1)
              steps1 + steps2
            else
              false
            end

          y1 == y2 and xp1 == xp2 ->
            if yp1 < y1 and yp2 > y1 and xp1 <= max(x1, x2) and xp1 >= min(x1, x2) do
              IO.inspect("#{dist1}, #{dist2}")

              steps1 = dist1 + abs(if dir1 == "R", do: x1 - xp1, else: x2 - xp1)
              steps2 = dist2 + abs(if dir2 == "U", do: y1 - yp1, else: y2 - yp1)
              steps1 + steps2
            else
              false
            end

          true ->
            false
        end
      end)
    end)
    |> Enum.filter(&(&1 != false))
    |> IO.inspect()
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.map(
      &(&1
        |> String.split(",")
        |> Enum.map(fn <<d, dist::binary>> -> {<<d>>, String.to_integer(dist)} end))
    )
  end
end
