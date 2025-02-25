defmodule Day08 do
  def part_1(file) do
    input = get_input(file)

    input
    |> Enum.chunk_every(150)
    |> Enum.map(&Enum.frequencies/1)
    |> Enum.min_by(fn freqs -> Map.get(freqs, 0) end)
    |> then(&(Map.get(&1, 1) * Map.get(&1, 2)))
    |> IO.inspect()
  end

  # 0 is black 1 is white 2 is transparent
  def part_2(file) do
    input = get_input(file)

    input
    |> Enum.chunk_every(150)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn pos -> Enum.find(pos, &(&1 != 2)) end)
    |> Enum.map(fn
      0 -> "."
      1 -> "#"
    end)
    |> then(&Enum.chunk_every(&1, 25))
    |> print_image()
  end

  defp print_image(rows) do
    rows
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> IO.puts()

    rows
  end

  defp get_input(file) do
    File.read!(file)
    |> String.replace("\n", "")
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end
end
