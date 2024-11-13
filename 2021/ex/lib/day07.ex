defmodule Day07 do
  def part_1(file) do
    numbers = parse_input(file)

    {min, max} = numbers |> Enum.min_max()

    for n <- numbers do
      for m <- min..max, do: abs(n - m)
    end
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.sum/1)
    |> Enum.min()
  end

  def part_2(file) do
    numbers = parse_input(file)

    {min, max} = numbers |> Enum.min_max()

    for n <- numbers do
      for m <- min..max, do: calc_travel(abs(n - m))
    end
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.sum/1)
    |> Enum.min()
  end

  def parse_input(file) do
    file
    |> File.read!()
    |> String.split([",", "\n"])
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.to_integer/1)
  end

  def calc_travel(distance) do
    1..distance |> Enum.sum()
  end
end
