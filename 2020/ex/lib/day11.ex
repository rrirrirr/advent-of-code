defmodule Day11 do
  def part_1(file) do
    input = get_input(file)

    grid =
      input
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, y} ->
        Enum.with_index(row) |> Enum.map(fn {c, x} -> {{x, y}, c} end)
      end)

    h = length(input)
    l = length(hd(input))

    1..100_000
    |> Enum.reduce_while(grid, fn _, acc ->
      map = acc |> Map.new()

      ng =
        acc
        |> Enum.map(fn {{x, y}, c} ->
          window = w(map, {x, y}, h, l)

          cond do
            c == "L" ->
              if Enum.all?(window, &(&1 != "#")) do
                {{x, y}, "#"}
              else
                {{x, y}, "L"}
              end

            c == "#" ->
              if Enum.count(window, &(&1 == "#")) > 3 do
                {{x, y}, "L"}
              else
                {{x, y}, "#"}
              end

            c == "." ->
              {{x, y}, "."}
          end
        end)

      if ng == acc do
        {:halt, ng}
      else
        {:cont, ng}
      end
    end)
    |> Enum.count(fn {_, c} -> c == "#" end)
    |> IO.inspect()
  end

  def part_2(file) do
    input = get_input(file)

    grid =
      input
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, y} ->
        Enum.with_index(row) |> Enum.map(fn {c, x} -> {{x, y}, c} end)
      end)

    h = length(input)
    l = length(hd(input))

    1..100_000
    |> Enum.reduce_while(grid, fn _, acc ->
      map = acc |> Map.new()

      ng =
        acc
        |> Enum.map(fn {{x, y}, c} ->
          window = w_2(map, {x, y}, h, l)

          cond do
            c == "L" ->
              if Enum.all?(window, &(&1 != "#")) do
                {{x, y}, "#"}
              else
                {{x, y}, "L"}
              end

            c == "#" ->
              if Enum.count(window, &(&1 == "#")) > 4 do
                {{x, y}, "L"}
              else
                {{x, y}, "#"}
              end

            c == "." ->
              {{x, y}, "."}
          end
        end)

      if ng == acc do
        {:halt, ng}
      else
        {:cont, ng}
      end
    end)
    |> Enum.count(fn {_, c} -> c == "#" end)
    |> IO.inspect()
  end

  defp w(map, {x, y}, h, l) do
    [
      {0, -1},
      {0, 1},
      {-1, 0},
      {1, 0},
      {-1, -1},
      {1, -1},
      {-1, 1},
      {1, 1}
    ]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.filter(&ib(&1, h, l))
    |> Enum.map(&Map.get(map, &1))
  end

  defp w_2(map, {x, y}, h, l) do
    [
      {0, -1},
      {0, 1},
      {-1, 0},
      {1, 0},
      {-1, -1},
      {1, -1},
      {-1, 1},
      {1, 1}
    ]
    |> Enum.map(fn {dx, dy} -> t(map, {x + dx, y + dy}, {dx, dy}, h, l) end)
    |> Enum.filter(& &1)
  end

  defp t(map, {x, y}, {dx, dy}, h, l) do
    cond do
      not ib({x, y}, h, l) ->
        false

      Map.get(map, {x, y}) == "." ->
        t(map, {x + dx, y + dy}, {dx, dy}, h, l)

      true ->
        Map.get(map, {x, y})
    end
  end

  defp ib({x, y}, h, l) do
    x >= 0 and x < l and y >= 0 and y < h
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
