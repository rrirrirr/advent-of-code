defmodule Day01 do
  def count_increases({val, []}), do: val
  def count_increases({val, [_head]}), do: val

  def count_increases({val, [first, second | rest]}) do
    new_val = if second > first, do: val + 1, else: val
    count_increases({new_val, [second | rest]})
  end

  def part1(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.to_integer/1)
    |> then(&count_increases({0, &1}))
  end

  def part1_enum(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> b > a end)
  end

  def part1_zip(filename) do
    numbers =
      filename
      |> File.read!()
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.to_integer/1)

    numbers
    |> tl()
    |> Enum.zip(numbers)
    |> Enum.count(fn {curr, prev} -> curr > prev end)
  end

  def part2(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> b > a end)
  end
end
