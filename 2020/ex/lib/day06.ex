defmodule Day06 do
  def part_1(file) do
    input = get_input(file)

    input
    |> Enum.map(fn group -> String.replace(group, ["\n"], "") end)
    |> Enum.map(fn g ->
      String.graphemes(g)
      |> MapSet.new()
    end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(file) do
    input = get_input(file)

    input
    |> Enum.map(fn group ->
      String.split(group, "\n", trim: true)
      |> Enum.map(&MapSet.new(String.graphemes(&1)))
      |> Enum.reduce(&MapSet.intersection/2)
      |> MapSet.size()
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n\n"], trim: true)
  end
end
