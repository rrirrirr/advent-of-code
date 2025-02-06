defmodule Day01 do
  def part_1(file) do
    get_input(file)
    |> Enum.map(&(div(&1, 3) - 2))
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(file) do
    get_input(file)
    |> Enum.map(fn mass ->
      1..1000
      |> Enum.reduce_while({mass, 0}, fn _, {left, total} ->
        left = div(left, 3) - 2

        if left <= 0 do
          {:halt, total}
        else
          {:cont, {left, total + left}}
        end
      end)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
