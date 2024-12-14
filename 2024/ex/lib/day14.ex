defmodule Day14 do
  def part_1(file) do
    width = 101
    height = 103

    get_input(file)
    |> Enum.map(&travel(&1, 100, width, height))
    |> find_quadrants(width, height)
    |> Enum.map(&Enum.count/1)
    |> Enum.product()
    |> IO.inspect()
  end

  def part_2(file) do
    width = 101
    height = 103

    robots = get_input(file)

    1..100_00000
    |> Enum.reduce_while({robots, :infinity}, fn step, {current_positions, min_distance} ->
      updated_positions =
        current_positions
        |> Enum.map(&update_robot(&1, width, height))

      current_distance =
        calc_distances(updated_positions, width, height)

      if current_distance < 16000 do
        IO.inspect(current_distance, label: "Step #{step}")
        print_grid(updated_positions)
        {:halt, step}
      else
        {:cont, {updated_positions, min_distance}}
      end
    end)
    |> IO.inspect()
  end

  defp update_robot({x, y, vx, vy}, width, height) do
    {
      rem(rem(x + vx, width) + width, width),
      rem(rem(y + vy, height) + height, height),
      vx,
      vy
    }
  end

  defp calc_distances(nodes, width, height) do
    center_x = div(width, 2)
    center_y = div(height, 2)

    nodes
    |> Enum.map(fn {x, y, _vx, _vy} ->
      abs(x - center_x) + abs(y - center_y)
    end)
    |> Enum.sum()
  end

  defp print_grid(robots) do
    IO.write("\e[2J\e[H")

    for y <- 0..102 do
      for x <- 0..100 do
        case Enum.any?(robots, fn {rx, ry, _, _} -> rx == x && ry == y end) do
          true -> IO.write("#")
          false -> IO.write(".")
        end
      end

      IO.write("\n")
    end

    Process.sleep(2000)
  end

  defp travel({x, y, vx, vy}, steps, width, height) do
    {
      rem(rem(x + vx * steps, width) + width, width),
      rem(rem(y + vy * steps, height) + height, height)
    }
  end

  defp find_quadrants(robots, width, height) do
    [
      {0, Integer.floor_div(width, 2) - 1, 0, Integer.floor_div(height, 2) - 1},
      {ceil(width / 2), width - 1, 0, Integer.floor_div(height, 2) - 1},
      {0, Integer.floor_div(width, 2) - 1, ceil(height / 2), height - 1},
      {ceil(width / 2), width - 1, ceil(height / 2), height - 1}
    ]
    |> Enum.map(fn {x1, x2, y1, y2} ->
      robots
      |> Enum.filter(fn {x, y} -> x >= x1 and x <= x2 and y >= y1 and y <= y2 end)
    end)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n", "p=", "v=", " ", ","], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4)
    |> Enum.map(&List.to_tuple/1)

    # |> Enum.chunk_every(2)
  end
end
