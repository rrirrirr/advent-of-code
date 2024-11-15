defmodule Day11 do
  def part_1(file) do
    input = get_input(file)
    graph = build_graph(input)

    paths = travel(graph, "start", [], MapSet.new([]))
    length(paths)
  end

  def part_2(file) do
    input = get_input(file)
    graph = build_graph(input)

    paths = travel_2(graph, "start", [], MapSet.new([]), false)
    length(paths)
  end

  def travel_2(_, "end", visited, _, _), do: [["end" | visited]]

  def travel_2(graph, to, visited, small_cave_visited, true) do
    if is_small_cave?(to) and MapSet.member?(small_cave_visited, to) do
      []
    else
      updated_visited = [to | visited]
      updated_small_cave_visited = update_small_cave_visited(to, small_cave_visited)

      Map.get(graph, to, [])
      |> Enum.flat_map(&travel_2(graph, &1, updated_visited, updated_small_cave_visited, true))
    end
  end

  def travel_2(graph, to, visited, small_cave_visited, false) do
    cond do
      to == "start" && length(visited) > 0 ->
        []

      is_small_cave?(to) and MapSet.member?(small_cave_visited, to) ->
        updated_visited = [to | visited]
        updated_small_cave_visited = update_small_cave_visited(to, small_cave_visited)

        Map.get(graph, to, [])
        |> Enum.flat_map(&travel_2(graph, &1, updated_visited, updated_small_cave_visited, true))

      true ->
        updated_visited = [to | visited]
        updated_small_cave_visited = update_small_cave_visited(to, small_cave_visited)

        Map.get(graph, to, [])
        |> Enum.flat_map(&travel_2(graph, &1, updated_visited, updated_small_cave_visited, false))
    end
  end

  def travel(_, "end", visited, _), do: [["end" | visited]]

  def travel(graph, to, visited, small_cave_visited) do
    if is_small_cave?(to) and MapSet.member?(small_cave_visited, to) do
      []
    else
      updated_visited = [to | visited]
      updated_small_cave_visited = update_small_cave_visited(to, small_cave_visited)

      Map.get(graph, to, [])
      |> Enum.flat_map(&travel(graph, &1, updated_visited, updated_small_cave_visited))
    end
  end

  defp update_small_cave_visited(to, visited) do
    if is_small_cave?(to), do: MapSet.put(visited, to), else: visited
  end

  defp is_small_cave?(cave) do
    String.match?(cave, ~r/[a-z]/)
  end

  def build_graph(input) do
    input
    |> Enum.reduce(%{}, fn [from, to], acc ->
      acc
      |> Map.update(from, MapSet.new([to]), &MapSet.put(&1, to))
      |> Map.update(to, MapSet.new([from]), &MapSet.put(&1, from))
    end)
  end

  def get_input(file) do
    File.read!(file)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.split(&1, "-"))
  end
end
