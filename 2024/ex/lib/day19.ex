defmodule Day19 do
  def part_1(file) do
    {towels, wanted} = get_input(file)
    sorted_towels = Enum.sort_by(towels, &String.length/1, :desc)
    cache = :ets.new(:memo_cache, [:set, :public])

    wanted
    |> Enum.with_index()
    |> Task.async_stream(
      fn {w, _idx} ->
        can_be_made(sorted_towels, w, cache)
      end,
      max_concurrency: System.schedulers_online(),
      timeout: 10_000,
      ordered: false
    )
    |> Enum.reduce(0, fn
      {:ok, true}, acc ->
        acc + 1

      {:ok, false}, acc ->
        acc
    end)
    |> IO.inspect()
  end

  def part_2(file) do
    {towels, wanted} = get_input(file)
    sorted_towels = Enum.sort_by(towels, &String.length/1, :desc)
    cache = :ets.new(:memo_cache, [:set, :public])

    wanted
    |> Enum.with_index()
    |> Task.async_stream(
      fn {w, _idx} ->
        possible_designs(sorted_towels, w, cache)
      end,
      max_concurrency: System.schedulers_online(),
      timeout: 10_000,
      ordered: false
    )
    |> Enum.reduce(0, fn
      {:ok, score}, acc ->
        acc + score
    end)
    |> IO.inspect()
  end

  defp can_be_made(_, "", _) do
    true
  end

  defp can_be_made([], wanted, _) when wanted != "", do: false

  defp can_be_made(towels, wanted, cache) do
    case(:ets.lookup(cache, {wanted})) do
      [{_, result}] ->
        result

      _ ->
        result =
          towels
          |> Enum.any?(fn towel ->
            if String.starts_with?(wanted, towel) do
              rest = String.replace_prefix(wanted, towel, "")
              can_be_made(towels, rest, cache)
            else
              false
            end
          end)

        :ets.insert(cache, {{wanted}, result})
        result
    end
  end

  defp possible_designs(_, "", _) do
    1
  end

  defp possible_designs([], wanted, _) when wanted != "", do: 0

  defp possible_designs(towels, wanted, cache) do
    case(:ets.lookup(cache, {wanted})) do
      [{_, result}] ->
        result

      _ ->
        result =
          towels
          |> Enum.reduce(0, fn towel, sum ->
            if String.starts_with?(wanted, towel) do
              rest = String.replace_prefix(wanted, towel, "")
              sum + possible_designs(towels, rest, cache)
            else
              sum + 0
            end
          end)

        :ets.insert(cache, {{wanted}, result})
        result
    end
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n\n", trim: true)
    |> then(fn [p1, p2] ->
      towels =
        p1
        |> String.split(", ", trim: true)

      wanted = p2 |> String.split("\n", trim: true)
      {towels, wanted}
    end)
  end
end
