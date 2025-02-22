defmodule Day06 do
  def part_1(file) do
    map = get_input(file)

    count(map, "COM", 0)
    |> IO.inspect()
  end

  def part_2(file) do
    map_from = get_input_2(file)
    map_to = get_input(file)

    find_path([{"YOU", 0}], map_from, map_to, MapSet.new())
    |> IO.inspect()
  end

  defp find_path([{current, n} | rest], mf, mt, visited) do
    cond do
      MapSet.member?(visited, current) ->
        find_path(rest, mf, mt, visited)

      current == "SAN" ->
        n - 2

      true ->
        visited = MapSet.put(visited, current)
        from = if Map.has_key?(mf, current), do: [Map.get(mf, current)], else: []
        to = Map.get(mt, current, [])
        ne = Enum.map(from ++ to, &{&1, n + 1})
        find_path(rest ++ ne, mf, mt, visited)
    end
  end

  defp count(map, current, n) do
    if Map.has_key?(map, current) do
      Map.get(map, current)
      |> Enum.sum_by(fn d -> count(map, d, n + 1) end)
      |> then(fn s -> s + n end)
    else
      n
    end
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n", ")"], trim: true)
    |> Enum.chunk_every(2)
    |> Enum.reduce(%{}, fn [key, d], map ->
      Map.update(map, key, [d], fn l -> [d] ++ l end)
    end)
    |> Map.new()
  end

  defp get_input_2(file) do
    File.read!(file)
    |> String.split(["\n", ")"], trim: true)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [f, d] -> {d, f} end)
    |> Map.new()
  end
end
