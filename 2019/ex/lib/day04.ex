defmodule Day04 do
  def part_1(file) do
    [from, to] = get_input(file)

    from..to
    |> Enum.map(&Integer.digits/1)
    |> Enum.filter(&is_valid(&1))
    |> Enum.count()
    |> IO.inspect()
  end

  def part_2(file) do
    [from, to] = get_input(file)

    from..to
    |> Enum.map(&Integer.digits/1)
    |> Enum.filter(&is_valid_2(&1))
    |> Enum.count()
    |> IO.inspect()
  end

  defp is_valid(n, last \\ -1, has_adjacent \\ false)
  defp is_valid([], _, false), do: false
  defp is_valid([], _, true), do: true
  defp is_valid([n | _], last, _) when n < last, do: false
  defp is_valid([n | rest], last, _) when n == last, do: is_valid(rest, n, true)
  defp is_valid([n | rest], _, has_adjacent), do: is_valid(rest, n, has_adjacent)

  defp is_valid_2(digits) do
    digits
    |> Enum.chunk_by(& &1)
    |> Enum.any?(fn group -> length(group) == 2 end) &&
      digits == Enum.sort(digits)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n", "-"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
