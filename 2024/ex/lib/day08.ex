defmodule Day08 do
  def part_1(file) do
    input = get_input(file)
    width = length(hd(input))
    height = length(input)

    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn
        {".", _} -> :empty
        {t, x} -> {t, {x, y}}
      end)
    end)
    |> Enum.reject(&(&1 == :empty))
    |> Enum.reduce(%{}, fn {key, coords}, acc ->
      Map.update(acc, key, [coords], &(&1 ++ [coords]))
    end)
    |> then(fn map ->
      Map.keys(map)
      |> Enum.map(&Map.get(map, &1))
    end)
    |> Enum.flat_map(&pairs/1)
    |> Enum.flat_map(&antinodes/1)
    |> Enum.filter(&is_inbounds(&1, width, height))
    |> Enum.uniq()
    |> Enum.count()
    |> IO.inspect()
  end

  def part_2(file) do
    input = get_input(file)
    width = length(hd(input))
    height = length(input)

    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn
        {".", _} -> :empty
        {t, x} -> {t, {x, y}}
      end)
    end)
    |> Enum.reject(&(&1 == :empty))
    |> Enum.reduce(%{}, fn {key, coords}, acc ->
      Map.update(acc, key, [coords], &(&1 ++ [coords]))
    end)
    |> then(fn map ->
      Map.keys(map)
      |> Enum.map(&Map.get(map, &1))
    end)
    |> Enum.flat_map(&pairs/1)
    |> Enum.flat_map(&antinodes_2(&1, width, height))
    |> Enum.uniq()
    |> Enum.count()
    |> IO.inspect()
  end

  defp is_inbounds({x, y}, width, height) do
    x >= 0 and x < width and y >= 0 and y < height
  end

  defp antinodes({{x1, y1}, {x2, y2}}) do
    dy = y1 - y2
    dx = x1 - x2
    [{x1 + dx, y1 + dy}, {x2 - dx, y2 - dy}]
  end

  defp antinodes_2({{x1, y1}, {x2, y2}}, width, height) do
    dy = y1 - y2
    dx = x1 - x2

    gcd = Integer.gcd(abs(dx), abs(dy))
    step_x = div(dx, gcd)
    step_y = div(dy, gcd)

    d1 =
      Stream.iterate({x1, y1}, fn {x, y} -> {x + step_x, y + step_y} end)
      |> Stream.take_while(fn {x, y} ->
        x >= 0 and x < width and y >= 0 and y < height
      end)
      |> Enum.to_list()

    d2 =
      Stream.iterate({x1 - step_x, y1 - step_y}, fn {x, y} -> {x - step_x, y - step_y} end)
      |> Stream.take_while(fn {x, y} ->
        x >= 0 and x < width and y >= 0 and y < height
      end)
      |> Enum.to_list()

    d1 ++ d2
  end

  defp pairs([]), do: []

  defp pairs([head | tail]) do
    f = Enum.map(tail, &{head, &1})
    f ++ pairs(tail)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
