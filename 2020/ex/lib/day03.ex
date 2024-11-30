defmodule Day03 do
  def part_1(file) do
    input = get_input(file)
    row_visits = length(input)

    row_length = length(hd(input))

    Enum.reduce(0..(row_visits - 2), {0, 0}, fn y, {x, trees} ->
      new_xs = (x + 1)..(x + 3) |> Enum.map(&rem(&1, row_length))
      x = List.last(new_xs)
      current = input |> Enum.at(y + 1) |> Enum.at(x)

      if current == "#" do
        {x, trees + 1}
      else
        {x, trees}
      end
    end)
    |> elem(1)
  end

  def part_2(file) do
    input = get_input(file)

    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(&traverse(input, &1))
    |> Enum.product()
  end

  defp traverse(input, {right, down}) do
    row_visits = length(input)

    row_length = length(hd(input))

    Enum.reduce(0..(row_visits - 2)//down, {0, 0}, fn y, {x, trees} ->
      new_xs = (x + 1)..(x + right) |> Enum.map(&rem(&1, row_length))
      x = List.last(new_xs)
      current = input |> Enum.at(y + down) |> Enum.at(x)

      if current == "#" do
        {x, trees + 1}
      else
        {x, trees}
      end
    end)
    |> elem(1)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.graphemes/1)
  end
end
