defmodule Day14 do
  def part_1(file) do
    {template, insertions} = get_input(file)

    1..10
    |> Enum.reduce(template, fn _, current_template ->
      step(current_template, insertions)
    end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.min_max()
    |> then(fn {min, max} -> max - min end)
  end

  def part_2(file, steps) do
    {template, insertions} = get_input(file)

    initial_pairs =
      template
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> "#{a}#{b}" end)
      |> Enum.frequencies()

    last_letter = List.last(template)

    final_pairs =
      Enum.reduce(1..steps, initial_pairs, fn _step, pairs ->
        step_2(pairs, insertions)
      end)

    final_pairs
    |> Map.to_list()
    |> Enum.reduce(%{}, fn {s, v}, acc ->
      [f, _] = String.graphemes(s)
      Map.update(acc, f, v, &(&1 + v))
    end)
    |> Map.update(last_letter, 1, &(&1 + 1))
    |> Map.to_list()
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.min_max()
    |> then(fn {min, max} -> max - min end)
  end

  defp step_2(pairs, rules) do
    pairs
    |> Enum.reduce(%{}, fn {pair, count}, acc ->
      insert = Map.get(rules, pair)
      [a, b] = String.graphemes(pair)

      acc
      |> Map.update("#{a}#{insert}", count, &(&1 + count))
      |> Map.update("#{insert}#{b}", count, &(&1 + count))
    end)
  end

  defp step(template, insertions) do
    template
    |> Enum.chunk_every(2, 1)
    |> Enum.flat_map(fn
      [f, l] -> [f, Map.get(insertions, f <> l)]
      [f] -> [f]
    end)
  end

  defp get_input(file) do
    [templates, insertions] =
      File.read!(file) |> String.split("\n\n")

    parsed_insertions =
      insertions
      |> String.split(["\n", " -> "])
      |> Enum.filter(&(&1 != ""))
      |> Enum.chunk_every(2)
      |> Enum.reduce(%{}, fn [from, to], acc ->
        Map.put(acc, from, to)
      end)

    chunked_templates = templates |> String.graphemes()
    {chunked_templates, parsed_insertions}
  end
end
