defmodule Day06 do
  def part_1(file) do
    file
    |> parse_input()
    |> simulate_days(80)
  end

  def part_2(file) do
    fish = parse_input(file)
    spawn_counts = calculate_spawn_counts(256)

    fish
    |> Enum.map(&Enum.at(spawn_counts, 255 - &1))
    |> Enum.sum()
    |> Kernel.+(length(fish))
  end

  defp parse_input(file) do
    file
    |> File.read!()
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp simulate_days(fish, days) do
    1..days
    |> Enum.reduce(fish, fn _day, current_fish ->
      Enum.flat_map(current_fish, &process_fish/1)
    end)
    |> length()
  end

  defp process_fish(0), do: [6, 8]
  defp process_fish(fish), do: [fish - 1]

  defp calculate_spawn_counts(max_days) do
    0..max_days
    |> Enum.reduce([], &(&2 ++ [count_fish(&2, &1)]))
  end

  defp count_fish(_, day) when day < 0, do: 0
  defp count_fish(_, day) when day < 7, do: 1

  defp count_fish(fish_list, day) when length(fish_list) > day,
    do: Enum.at(fish_list, day)

  defp count_fish(fish_list, day) do
    day..0//-7
    |> Enum.to_list()
    |> Enum.map(&count_fish(fish_list, &1 - 9))
    |> Enum.map(&(&1 + 1))
    |> Enum.sum()
  end
end
