defmodule Day03 do
  def part_1(file) do
    get_input(file)
    |> calc()
    |> IO.inspect()
  end

  # split on first don't() extract mults on head and look for do() on tail. repeat 

  def part_2(file) do
    input = get_input(file)

    solve(input, 0)
    |> IO.inspect()
  end

  defp solve("", sum), do: sum

  defp solve(input, sum) do
    [head, tail] =
      split_on_first_dont(input)

    sum_of_head = calc(head)

    next =
      split_on_first_do(tail)

    solve(next, sum_of_head + sum)
  end

  defp calc(input) do
    input
    |> extract_muls()
    |> calc_prods()
    |> Enum.sum()
  end

  defp split_on_first_dont(input) do
    case String.split(input, "don't()", parts: 2) do
      [single] -> [single, ""]
      [head, tail] -> [head, tail]
    end
  end

  defp split_on_first_do(input) do
    case String.split(input, "do()", parts: 2) do
      [_single] -> ""
      [_head, tail] -> tail
    end
  end

  defp extract_muls(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, input, capture: :all_but_first)
  end

  defp calc_prods(matches) do
    matches
    |> Enum.map(fn nums ->
      nums
      |> Enum.map(&String.to_integer/1)
      |> Enum.product()
    end)
  end

  defp get_input(file) do
    File.read!(file)
  end
end
