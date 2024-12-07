defmodule Day07 do
  def part_1(file) do
    get_input(file)
    |> Enum.map(fn {test_value, numbers} ->
      numbers
      |> solve_equations_ltr([], :start)
      |> Enum.member?(test_value)
      |> then(fn
        true -> test_value
        false -> 0
      end)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(file) do
    get_input(file)
    |> Task.async_stream(
      fn {test_value, numbers} ->
        numbers
        |> solve_equations_ltrc([], :start)
        |> Enum.member?(test_value)
        |> then(fn
          true -> test_value
          false -> 0
        end)
      end,
      max_concurrency: System.schedulers_online()
    )
    |> Stream.map(fn {:ok, result} -> result end)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp solve_equations_ltrc([], acc, _) do
    acc
  end

  defp solve_equations_ltrc([v | rest], [], _) do
    solve_equations_ltrc(rest, v, :nothing)
    |> List.flatten()
  end

  defp solve_equations_ltrc(["|" | rest], acc, _) do
    [
      solve_equations_ltrc(rest, acc, :plus),
      solve_equations_ltrc(rest, acc, :mult),
      solve_equations_ltrc(rest, acc, :concat)
    ]
  end

  defp solve_equations_ltrc([v | rest], acc, :plus) do
    solve_equations_ltrc(rest, v + acc, :nothing)
  end

  defp solve_equations_ltrc([v | rest], acc, :mult) do
    solve_equations_ltrc(rest, v * acc, :nothing)
  end

  defp solve_equations_ltrc([v | rest], acc, :concat) do
    solve_equations_ltrc(rest, "#{acc}#{v}" |> String.to_integer(), :nothing)
  end

  defp solve_equations_ltr([], acc, _) do
    acc
  end

  defp solve_equations_ltr([v | rest], [], _) do
    solve_equations_ltr(rest, v, :nothing)
    |> List.flatten()
  end

  defp solve_equations_ltr(["|" | rest], acc, _) do
    [
      solve_equations_ltr(rest, acc, :plus),
      solve_equations_ltr(rest, acc, :mult)
    ]
  end

  defp solve_equations_ltr([v | rest], acc, :plus) do
    solve_equations_ltr(rest, v + acc, :nothing)
  end

  defp solve_equations_ltr([v | rest], acc, :mult) do
    solve_equations_ltr(rest, v * acc, :nothing)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [test_value, numbers] ->
      values =
        numbers
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
        |> Enum.intersperse("|")

      {String.to_integer(test_value), values}
    end)
  end
end
