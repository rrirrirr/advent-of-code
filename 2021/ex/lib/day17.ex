defmodule Day17 do
  def part_1(file) do
    {rx, ry} = get_input(file)
    v = generate_speeds(rx, ry)

    v
    |> Enum.map(&send_probe(&1, rx, ry))
    |> Enum.filter(fn {{x, _}, _, _, _} -> x != 0 end)
    |> Enum.map(fn {_, _, highest_point, _} -> highest_point end)
    |> Enum.max()
  end

  def part_2(file) do
    {rx, ry} = get_input(file)
    v = generate_speeds(rx, ry)

    v
    |> Enum.map(&send_probe(&1, rx, ry))
    |> Enum.filter(fn {{x, _}, _, _, _} -> x != 0 end)
    |> Enum.count()
  end

  defp send_probe({vx, vy}, {_rxs, rxe} = rx_range, {rys, _rye} = ry_range) do
    initial_state = {{0, 0}, {vx, vy}, 0, {vx, vy}}

    Enum.reduce_while(1..200, initial_state, fn _, {pos, speed, max_y, start} ->
      cond do
        has_passed_range?(pos, rxe, rys) ->
          {:halt, {{0, 0}, {0, 0}, 0, start}}

        is_in_range?(pos, rx_range, ry_range) ->
          {:halt, {pos, {0, 0}, max_y, start}}

        true ->
          new_pos = step(pos, speed)
          new_speed = update_speed(speed)
          new_max_y = max(max_y, elem(pos, 1))
          {:cont, {new_pos, new_speed, new_max_y, start}}
      end
    end)
  end

  defp generate_speeds({rx_start, rx_end}, {ry_start, _ry_end}) do
    min_x =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.find(fn n ->
        n * (n + 1) / 2 >= rx_start
      end)

    max_x = rx_end
    min_y = ry_start
    max_y = abs(min_y)

    for x <- min_x..max_x, y <- min_y..max_y, do: {x, y}
  end

  defp has_passed_range?({x, y}, rx_end, ry_start) do
    x > rx_end or y < ry_start
  end

  defp is_in_range?({x, y}, {rx_start, rx_end}, {ry_start, ry_end}) do
    x >= rx_start and x <= rx_end and y >= ry_start and y <= ry_end
  end

  defp update_speed({0, vy}), do: {0, vy - 1}
  defp update_speed({vx, vy}), do: {vx - 1, vy - 1}

  defp step({x, y}, {vx, vy}) do
    {x + vx, y + vy}
  end

  defp get_input(file) do
    [_, x, y | _] = File.read!(file) |> String.split([": ", ", ", "\n"])

    x_area =
      x
      |> String.slice(2..-1//1)
      |> String.split("..")
      |> Enum.map(&String.to_integer/1)
      |> then(fn [a, b] -> {a, b} end)

    y_area =
      y
      |> String.slice(2..-1//1)
      |> String.split("..")
      |> Enum.map(&String.to_integer/1)
      |> then(fn [a, b] -> {a, b} end)

    {x_area, y_area}
  end
end
