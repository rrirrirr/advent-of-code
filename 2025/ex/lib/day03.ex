defmodule Day03 do
  def part_1(file) do
    get_input(file)
    |> Stream.map(fn line ->
      find_joltage(line, {}) |> then(&(elem(&1, 0) * 10 + elem(&1, 1)))
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(file) do
    get_input(file)
    |> Enum.map(fn line ->
      find_joltage_12(line, List.duplicate(0, 12))
      |> Enum.join()
      |> String.to_integer()
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp find_joltage_12([], acc), do: acc

  defp find_joltage_12([n | rest], acc) do
    limit = min(length(rest) + 1, 12)
    {unchanged, possibility} = Enum.split(acc, 12 - limit)

    {pre, suffix} = possibility |> Enum.split_while(fn pn -> n <= pn end)

    zeroes = List.duplicate(0, length(suffix))

    new_joltage = (unchanged ++ pre ++ [n] ++ zeroes) |> Enum.take(12)
    find_joltage_12(rest, new_joltage)
  end

  defp find_joltage([], acc), do: acc
  defp find_joltage([n | rest], {}), do: find_joltage(rest, {n})
  defp find_joltage([n], {f}), do: {f, n}
  defp find_joltage([n], {f, l}), do: {f, max(n, l)}

  defp find_joltage([n | rest], {f}) do
    if n > f do
      find_joltage(rest, {n})
    else
      find_joltage(rest, {f, n})
    end
  end

  defp find_joltage([n | rest], {f, l}) do
    cond do
      n > f -> find_joltage(rest, {n})
      n > l -> find_joltage(rest, {f, n})
      true -> find_joltage(rest, {f, l})
    end
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn l -> l |> Enum.map(&String.to_integer/1) end)
  end
end
