defmodule Day10 do
  def part_1(file) do
    input = get_input(file)

    input
    |> Enum.sort()
    |> Enum.reduce({[], 0}, fn n, {acc, last} ->
      {[n - last] ++ acc, n}
    end)
    |> elem(0)
    |> Enum.frequencies()
    |> then(&(Map.get(&1, 1) * (Map.get(&1, 3) + 1)))
    |> IO.inspect()
  end

  def part_2(file) do
    input = get_input(file)

    max = Enum.max(input)
    l = ([0, max + 3] ++ input) |> Enum.sort(:desc)

    cs(l, %{(max + 3) => 1})
    |> IO.inspect()
  end

  defp cs([n], m), do: Map.get(m, n)

  defp cs([n | rest], m) do
    nv = Map.get(m, n)

    m =
      rest
      |> Enum.take(3)
      |> Enum.reduce(m, fn nn, mm ->
        if n - nn <= 3 do
          Map.update(mm, nn, nv, &(&1 + nv))
        else
          mm
        end
      end)

    cs(rest, m)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
