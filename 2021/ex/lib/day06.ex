defmodule Day06 do
  def part_1(file) do
    fish = parse_input(file)

    1..80
    |> Enum.reduce(fish, fn _day, current_fish ->
      Enum.flat_map(current_fish, &process_fish/1)
    end)
    |> length()
  end

  def part_2(file) do
    fish =
      parse_input(file)

    fish_per_day =
      1..20
      |> Enum.reduce([], fn day, fish_list ->
        fish_list ++ [count_fish(fish_list, day)]
      end)

    fish_per_day |> Enum.with_index()
    # Enum.map(fish, &Enum.at(fish_per_day, 20 - &1)) |> Enum.sum()
  end

  defp parse_input(file) do
    File.read!(file)
    |> String.split([",", "\n"])
    |> Enum.filter(&(&1 != "" and &1 != "\n"))
    |> Enum.map(&String.to_integer/1)
  end

  defp process_fish(0), do: [6, 8]
  defp process_fish(fish), do: [fish - 1]

  defp count_fish(_, day) when day < 1, do: 0
  defp count_fish(_, day) when day < 7, do: 1

  defp count_fish(fish_list, day) when length(fish_list) >= day,
    do: Enum.at(fish_list, day)

  # defp count_fish(fish_list, day) do
  #   spawn_days = day..0//-7 |> Enum.to_list()
  # IO.inspect("Day #{day}, spawn days: #{inspect(spawn_days)}")

  # spawns_of_spawns =
  #   for spawn_day <- spawn_days do
  #     count_fish(fish_list, spawn_day - 9)
  #   end

  # IO.inspect("Spawns: #{inspect(spawns_of_spawns)}")
  # IO.inspect("total: #{inspect(Enum.sum(spawns_of_spawns) + length(spawn_days))}")
  #   Enum.sum(spawns_of_spawns) + 1
  # end

  defp count_fish(fish_list, day) do
    # Enum.sum(&count_fish(fish_list, &1 - 9))
    spawn_days =
      day..0//-7 |> Enum.to_list() |> Enum.sum()

    IO.inspect("Spawn days: #{inspect(spawn_days)}")
    spawn_days + 1
  end
end
