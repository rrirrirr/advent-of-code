defmodule Day02 do
  def part_1(file) do
    get_input(file)
    |> solve()
  end

  def part_2(file) do
    input = get_input(file)
    correct_without_deletions = solve(input)

    correct_with_deletions =
      input
      |> Enum.map(fn row ->
        initial_acc = get_intital_acc(row)

        Enum.reduce_while(row, initial_acc, fn
          _v, {:unsafe, _} ->
            {:halt, :unsafe}

          v, {_, last_value} when abs(v - last_value) > 3 ->
            {:halt, :unsafe}

          v, {:increase, last_value} when v > last_value ->
            {:cont, {:increase, v}}

          v, {:decrease, last_value} when v < last_value ->
            {:cont, {:decrease, v}}

          _, _ ->
            {:halt, :unsafe}
        end)
      end)
      |> Enum.zip(input)
      |> Enum.filter(fn
        {:unsafe, _} -> true
        _ -> false
      end)
      |> Enum.map(fn {_, l} ->
        possible_combos =
          for n <- 0..(length(l) - 1),
              do: List.delete_at(l, n)

        possible_combos
        |> solve()
        |> min(1)
      end)
      |> Enum.sum()

    correct_with_deletions + correct_without_deletions
  end

  defp solve(list) do
    list
    |> Enum.map(fn row ->
      initial_acc = get_intital_acc(row)

      Enum.reduce_while(row, initial_acc, fn
        _v, {:unsafe, _} ->
          {:halt, :unsafe}

        v, {_, last_value} when abs(v - last_value) > 3 ->
          {:halt, :unsafe}

        v, {:increase, last_value} when v > last_value ->
          {:cont, {:increase, v}}

        v, {:decrease, last_value} when v < last_value ->
          {:cont, {:decrease, v}}

        _, _ ->
          {:halt, :unsafe}
      end)
    end)
    |> Enum.count(&(&1 != :unsafe))
  end

  defp get_intital_acc([v1, v2 | _]) when v1 > v2, do: {:decrease, v1 + 1}
  defp get_intital_acc([v1, v2 | _]) when v2 > v1, do: {:increase, v1 - 1}
  defp get_intital_acc(_), do: {:unsafe, 0}

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn row ->
      row
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
