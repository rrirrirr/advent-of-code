defmodule Day15 do
  def part_1(file) do
    input = get_input(file)

    map =
      input
      |> Enum.drop(-1)
      |> Enum.with_index()
      |> Enum.map(fn {n, i} -> {n, [i + 1]} end)
      |> Map.new()

    length(input)..2019
    |> Enum.reduce({Enum.at(input, -1), map}, fn step, {last, map} ->
      cond do
        Map.has_key?(map, last) ->
          last_used = Map.get(map, last) |> Enum.at(-1)
          num = step - last_used
          map = Map.update(map, last, [step], fn l -> l ++ [step] end)
          {num, map}

        true ->
          map = Map.put(map, last, [step])
          {0, map}
      end
    end)
    |> elem(0)
    |> IO.inspect()
  end

  def part_2(file) do
    input = get_input(file)

    map =
      input
      |> Enum.drop(-1)
      |> Enum.with_index(1)
      |> Map.new()

    arr = :array.new(29_999_999, default: 0)

    initial_arr =
      Enum.reduce(map, arr, fn {num, pos}, acc ->
        :array.set(num, pos, acc)
      end)

    length(input)..29_999_999
    |> Enum.reduce({List.last(input), initial_arr}, fn step, {last, arr} ->
      IO.inspect(step)
      last_pos = :array.get(last, arr)
      next_sum = if last_pos == 0, do: 0, else: step - last_pos
      {next_sum, :array.set(last, step, arr)}
    end)
    |> elem(0)
    |> IO.inspect()
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
