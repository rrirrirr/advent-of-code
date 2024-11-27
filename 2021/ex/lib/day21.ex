defmodule Day21 do
  require Integer

  def part_1 do
    # test input
    starting_positions = {{0, 4}, {0, 8}}
    # real input
    # starting_positions = {{0, 5}, {0, 6}}

    1..2000
    |> Enum.reduce_while(starting_positions, fn roll, {p1, p2} ->
      is_p1_turn = Integer.is_odd(roll)
      roll_sum = calculate_roll_sum(roll)

      updates = update_position(is_p1_turn, p1, p2, roll_sum)
      check_winner(updates, roll)
    end)
  end

  @dice_frequencies %{3 => 1, 4 => 3, 5 => 6, 6 => 7, 7 => 6, 8 => 3, 9 => 1}
  def part_2 do
    # test input
    # starting_positions = {{0, 4}, {0, 8}}
    # real input
    starting_positions = {{0, 5}, {0, 6}}

    play(starting_positions, true, %{}) |> then(fn {p1, p2} -> max(p1, p2) end)
  end

  defp play({{score1, _}, _}, _, _) when score1 >= 21, do: {1, 0}
  defp play({_, {score2, _}}, _, _) when score2 >= 21, do: {0, 1}

  defp play(state, is_p1_turn, cache) do
    case Map.get(cache, {state, is_p1_turn}) do
      nil ->
        result =
          Enum.reduce(@dice_frequencies, {0, 0}, fn {roll, freq}, {w1, w2} ->
            {new_w1, new_w2} =
              update_state(state, is_p1_turn, roll)
              |> play(!is_p1_turn, cache)

            {w1 + new_w1 * freq, w2 + new_w2 * freq}
          end)

        Map.put(cache, {state, is_p1_turn}, result)
        result

      result ->
        result
    end
  end

  defp update_state({p1, p2}, true, val) do
    {score, pos} = p1
    new_pos = rem(pos + val - 1, 10) + 1
    {{score + new_pos, new_pos}, p2}
  end

  defp update_state({p1, p2}, false, val) do
    {score, pos} = p2
    new_pos = rem(pos + val - 1, 10) + 1
    {p1, {score + new_pos, new_pos}}
  end

  defp calculate_roll_sum(roll) do
    (3 * roll)..(3 * roll - 2)//-1
    |> Enum.map(&(rem(&1 - 1, 100) + 1))
    |> Enum.sum()
  end

  defp update_position(true, {score, pos}, p2, roll_sum) do
    new_pos = new_position(pos + roll_sum)
    {{score + new_pos, new_pos}, p2}
  end

  defp update_position(false, p1, {score, pos}, roll_sum) do
    new_pos = new_position(pos + roll_sum)
    {p1, {score + new_pos, new_pos}}
  end

  defp check_winner({p1, p2} = updates, roll) do
    if max(elem(p1, 0), elem(p2, 0)) >= 1000 do
      {:halt, min(elem(p1, 0), elem(p2, 0)) * roll * 3}
    else
      {:cont, updates}
    end
  end

  defp new_position(pos), do: rem(pos - 1, 10) + 1
end
