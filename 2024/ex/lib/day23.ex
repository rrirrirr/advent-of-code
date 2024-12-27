defmodule Day23 do
  def part_1(file) do
    input = get_input(file)
    computers = get_computers_list(input)
    map = get_map(input)

    computers
    |> Enum.flat_map(fn computer ->
      get_3_connections(map, computer, 0, [computer], computer)
    end)
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq()
    |> Enum.filter(&starts_with_t/1)
    |> Enum.count()
    |> IO.inspect()
  end

  def part_2(file) do
    input = get_input(file)
    computers = get_computers_list(input) |> Enum.sort()
    map = get_map(input)

    find_max_clique(map, computers, [], [], %{})
    |> Enum.sort()
    |> Enum.join(",")
    |> IO.inspect()
  end

  defp starts_with_t(computers) do
    computers |> Enum.any?(&String.starts_with?(&1, "t"))
  end

  defp find_max_clique(_, [], current_clique, max_clique, _) do
    if length(current_clique) > length(max_clique) do
      current_clique
    else
      max_clique
    end
  end

  defp find_max_clique(_, candidates, current_clique, max_clique, _)
       when length(current_clique) + length(candidates) < length(max_clique) do
    max_clique
  end

  defp find_max_clique(map, candidates, current_clique, max_clique, cache) do
    candidates
    |> Enum.reduce({max_clique, cache}, fn computer, {acc_max, cache} ->
      # Sort both current clique and remaining candidates together to catch equivalent states
      remaining = Enum.reject(candidates, &(&1 == computer))
      cache_key = Enum.join((current_clique ++ remaining) |> Enum.sort(), ",")

      cond do
        Map.has_key?(cache, cache_key) ->
          # IO.inspect("cached for #{cache_key}")
          {Map.get(cache, cache_key), cache}

        is_member_of_lan(map, computer, current_clique) ->
          if length(current_clique) == 0, do: IO.inspect(computer)
          new_current_clique = [computer | current_clique]
          remaining = Enum.filter(remaining, &is_member_of_lan(map, &1, new_current_clique))

          new_max = find_max_clique(map, remaining, new_current_clique, acc_max, cache)
          updated_cache = Map.put(cache, cache_key, new_max)

          if length(new_max) > length(acc_max),
            do: {new_max, updated_cache},
            else: {acc_max, updated_cache}

        true ->
          {acc_max, cache}
      end
    end)
    |> elem(0)
  end

  defp is_member_of_lan(map, computer, group) do
    Enum.all?(group, fn member ->
      connections = Map.get(map, member, [])
      computer in connections
    end)
  end

  defp get_3_connections(map, current, steps, path, start) do
    Map.get(map, current, [])
    |> Enum.flat_map(fn next_computer ->
      cond do
        steps == 2 and next_computer == start ->
          [path]

        next_computer not in path and steps < 2 ->
          get_3_connections(map, next_computer, steps + 1, [next_computer | path], start)

        true ->
          []
      end
    end)
  end

  defp get_computers_list(connections) do
    connections
    |> Enum.flat_map(fn {c1, c2} -> [c1, c2] end)
    |> Enum.uniq()
  end

  defp get_map(connections) do
    connections
    |> Enum.reduce(%{}, fn {c1, c2}, acc ->
      acc
      |> Map.update(c1, [c2], fn existing -> [c2 | existing] end)
      |> Map.update(c2, [c1], fn existing -> [c1 | existing] end)
    end)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      [p1, p2] = String.split(row, "-")
      {p1, p2}
    end)
  end
end
