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

    {_best_position, count} = Enum.max_by(visible, fn {_, count} -> count end)
    IO.inspect(count)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
