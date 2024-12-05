defmodule Day05 do
  def part_1(file) do
    {rules, sequences} = parse_input(file)

    sequences
    |> Enum.map(&get_middle_value_with_rules(&1, rules))
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(file) do
    {rules, sequences} = parse_input(file)
    invalid_sequences = find_invalid_sequences(sequences, rules)

    invalid_sequences
    |> Enum.map(&find_correct_order(&1, rules))
    |> Enum.map(&get_middle_element/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp get_middle_value_with_rules(sequence, rules) do
    middle_value = Enum.at(sequence, div(length(sequence), 2))
    sequence_map = Enum.with_index(sequence) |> Enum.into(%{})

    if follows_rules?(sequence_map, rules), do: middle_value, else: 0
  end

  defp find_invalid_sequences(sequences, rules) do
    sequences
    |> Enum.with_index()
    |> Enum.filter(&sequence_violates_rules?(&1, rules))
    |> Enum.map(fn {_seq, idx} -> Enum.at(sequences, idx) end)
  end

  defp sequence_violates_rules?({sequence, _idx}, rules) do
    sequence_map = Enum.with_index(sequence) |> Enum.into(%{})
    not follows_rules?(sequence_map, rules)
  end

  defp find_correct_order(sequence, rules) do
    valid_rules = filter_applicable_rules(sequence, rules)
    build_ordered_sequence([], [], valid_rules)
  end

  defp filter_applicable_rules(sequence, rules) do
    Enum.filter(rules, fn [first, last] ->
      Enum.member?(sequence, first) and Enum.member?(sequence, last)
    end)
  end

  defp build_ordered_sequence(start_list, end_list, []), do: start_list ++ end_list

  defp build_ordered_sequence(start_list, end_list, rules) do
    {starts, ends} = get_endpoints(rules)
    start = MapSet.difference(starts, ends) |> Enum.at(0)
    last = MapSet.difference(ends, starts) |> Enum.at(0)

    intersection = MapSet.intersection(starts, ends)
    remaining_rules = Enum.reject(rules, fn [f, e] -> f == start or e == last end)

    case MapSet.size(intersection) do
      1 ->
        mid = Enum.at(MapSet.to_list(intersection), 0)

        build_ordered_sequence(
          start_list ++ [start],
          [mid, last] ++ end_list,
          remaining_rules
        )

      _ ->
        build_ordered_sequence(
          start_list ++ [start],
          [last] ++ end_list,
          remaining_rules
        )
    end
  end

  defp get_endpoints(rules) do
    starts = Enum.map(rules, fn [f, _] -> f end) |> MapSet.new()
    ends = Enum.map(rules, fn [_, e] -> e end) |> MapSet.new()
    {starts, ends}
  end

  defp get_middle_element(list), do: Enum.at(list, div(length(list), 2))

  defp follows_rules?(map, rules) do
    rules
    |> Enum.filter(fn [first, last] ->
      Map.has_key?(map, first) and Map.has_key?(map, last)
    end)
    |> Enum.all?(fn [first, last] ->
      Map.get(map, first) < Map.get(map, last)
    end)
  end

  defp parse_input(file) do
    [rules_part, sequences_part] = File.read!(file) |> String.split("\n\n", trim: true)

    rules = parse_rules(rules_part)
    sequences = parse_sequences(sequences_part)

    {rules, sequences}
  end

  defp parse_rules(rules_text) do
    rules_text
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&String.split(&1, "|"))
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
  end

  defp parse_sequences(sequences_text) do
    sequences_text
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
