defmodule Day12 do
  def part_1(file) do
    grid = get_input(file)

    {map, starts} =
      make_map(grid)

    starts
    |> Enum.reduce({0, MapSet.new()}, fn {letter, coord}, {sum, seen} ->
      find_area(map, letter, coord, seen)
      |> Enum.reduce({0, 0, []}, fn
        {:member, c}, {members, perims, mc} -> {members + 1, perims, [c | mc]}
        {:perimeter, _}, {members, perims, mc} -> {members, perims + 1, mc}
        _, acc -> acc
      end)
      |> then(fn {m, p, mc} ->
        {sum + m * p, MapSet.union(seen, MapSet.new(mc))}
      end)
    end)
    |> elem(0)
    |> IO.inspect()
  end

  def part_2(file) do
    grid = get_input(file)

    {map, starts} =
      make_map(grid)

    starts
    |> Enum.reduce({0, MapSet.new()}, fn {letter, coord}, {sum, seen} ->
      find_area_dir(map, letter, coord, seen)
      |> Enum.reduce({0, [], []}, fn
        {:member, c}, {members, perims, mc} ->
          {members + 1, perims, [c | mc]}

        {:perimeter, {coord, dir}}, {members, perims, mc} ->
          {members, [{coord, dir} | perims], mc}

        _, acc ->
          acc
      end)
      |> then(fn {m, ps, mc} ->
        walls =
          find_walls(ps)
          |> Enum.uniq()
          |> length()

        {sum + m * walls, MapSet.union(seen, MapSet.new(mc))}
      end)
    end)
    |> elem(0)
    |> IO.inspect()
  end

  defp find_walls([]), do: []

  defp find_walls(perims) do
    perims
    |> Enum.map(&create_wall(perims, &1))
  end

  defp create_wall(perims, {{x, y}, dir}) do
    case dir do
      dir when dir in [:up, :down] ->
        # p = perims |> Enum.filter(fn {{xp, _}, dirp} -> dirp == dir and xp == x end)

        {
          look_dir(perims, {{x - 1, y}, dir}, :left),
          look_dir(perims, {{x + 1, y}, dir}, :right)
        }

      dir when dir in [:left, :right] ->
        # p = perims |> Enum.filter(fn {{_, yp}, dirp} -> dirp == dir and yp == y end)

        {
          look_dir(perims, {{x, y - 1}, dir}, :up),
          look_dir(perims, {{x, y + 1}, dir}, :down)
        }
    end
  end

  defp look_dir(perims, {coord, dir}, look_dir) do
    {x, y} = coord

    case look_dir do
      :up ->
        if Enum.member?(perims, {{x, y}, dir}) do
          look_dir(perims, {{x, y - 1}, dir}, look_dir)
        else
          {{x, y + 1}, dir}
        end

      :down ->
        if Enum.member?(perims, {{x, y}, dir}) do
          look_dir(perims, {{x, y + 1}, dir}, look_dir)
        else
          {{x, y - 1}, dir}
        end

      :left ->
        if Enum.member?(perims, {{x, y}, dir}) do
          look_dir(perims, {{x - 1, y}, dir}, look_dir)
        else
          {{x + 1, y}, dir}
        end

      :right ->
        if Enum.member?(perims, {{x, y}, dir}) do
          look_dir(perims, {{x + 1, y}, dir}, look_dir)
        else
          {{x - 1, y}, dir}
        end
    end
  end

  defp find_area_dir(map, letter, start, seen) do
    visited = MapSet.new()

    bfs = fn bfs, queue, visited, results ->
      case :queue.out(queue) do
        {:empty, _} ->
          results

        {{:value, {coord, from_dir}}, rest_queue} ->
          cond do
            not is_map_key(map, coord) ->
              bfs.(bfs, rest_queue, visited, [{:perimeter, {coord, from_dir}} | results])

            MapSet.member?(visited, coord) ->
              bfs.(bfs, rest_queue, visited, results)

            Map.get(map, coord) == letter ->
              if MapSet.member?(seen, coord) do
                []
              else
                new_queue =
                  get_neighbours_dir(coord)
                  |> Enum.reduce(rest_queue, fn {x, y, dir}, q -> :queue.in({{x, y}, dir}, q) end)

                bfs.(bfs, new_queue, MapSet.put(visited, coord), [{:member, coord} | results])
              end

            true ->
              bfs.(bfs, rest_queue, visited, [{:perimeter, {coord, from_dir}} | results])
          end
      end
    end

    bfs.(bfs, :queue.from_list([{start, :start}]), visited, [])
  end

  def get_neighbours_dir({x, y}) do
    [
      {x + 1, y, :right},
      {x - 1, y, :left},
      {x, y + 1, :down},
      {x, y - 1, :up}
    ]
  end

  defp find_area(map, letter, start, seen) do
    visited = MapSet.new()

    bfs = fn bfs, queue, visited, results ->
      case :queue.out(queue) do
        {:empty, _} ->
          results

        {{:value, coord}, rest_queue} ->
          cond do
            not is_map_key(map, coord) ->
              bfs.(bfs, rest_queue, visited, [{:perimeter, coord} | results])

            MapSet.member?(visited, coord) ->
              bfs.(bfs, rest_queue, visited, results)

            Map.get(map, coord) == letter ->
              if MapSet.member?(seen, coord) do
                []
              else
                new_queue =
                  get_neighbours(coord)
                  |> Enum.reduce(rest_queue, &:queue.in/2)

                bfs.(bfs, new_queue, MapSet.put(visited, coord), [{:member, coord} | results])
              end

            true ->
              bfs.(bfs, rest_queue, visited, [{:perimeter, coord} | results])
          end
      end
    end

    bfs.(bfs, :queue.from_list([start]), visited, [])
  end

  def get_neighbours({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
  end

  defp make_map(grid) do
    starts =
      grid
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, y} ->
        Enum.with_index(row)
        |> Enum.map(fn {v, x} -> {v, {x, y}} end)
      end)

    coord_map = Enum.map(starts, fn {v, c} -> {c, v} end) |> Enum.into(%{})
    {coord_map, starts}
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
