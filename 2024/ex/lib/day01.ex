defmodule Day01 do
  def part_1(file) do
    file
    |> get_input()
    |> Enum.unzip()
    |> then(fn {l1, l2} ->
      Enum.zip(Enum.sort(l1), Enum.sort(l2))
    end)
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part_2(file) do
    {l1, l2} =
      file
      |> get_input()
      |> Enum.unzip()

    frequencies = Enum.frequencies(l2)

    l1
    |> Enum.map(&{Map.get(frequencies, &1, 0), &1})
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum()
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n", "   "], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [a, b] -> {a, b} end)
  end
end
