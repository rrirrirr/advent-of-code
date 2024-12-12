defmodule Day11 do
  # def part_1(file) do
  #   input = get_input(file)

  #   1..1_000_000
  #   |> Enum.reduce_while({input, %{}}, fn
  #     _, {[], map} ->
  #       {:halt, map}

  #     _, {[current | rest], map} ->
  #       case Map.has_key?(map, current) do
  #         true ->
  #           {:cont, {rest, map}}

  #         false ->
  #           {members, unprocessed} = find_cycle(current, MapSet.new(), [])
  #           cycle_size = MapSet.size(members)

  #           updated_map =
  #             Enum.to_list(members)
  #             |> Enum.into(map, fn num -> {num, cycle_size} end)

  #           {:cont, {unprocessed ++ rest, updated_map}}
  #       end
  #   end)
  #   |> IO.inspect()
  # end

  def part_1(file) do
    input = get_input(file)

    map =
      0..9
      |> Task.async_stream(
        fn v ->
          IO.inspect(v, label: "mapping")

          {_final_numbers, sizes} =
            1..40
            |> Enum.reduce({[v], []}, fn _step, {acc, sizes} ->
              update = acc |> Enum.flat_map(&transform/1)
              new_length = length(update)
              {update, [new_length | sizes]}
            end)

          Enum.reverse(sizes)
        end,
        timeout: :infinity,
        ordered: true,
        max_concurrency: 5
      )
      |> Enum.map(fn {:ok, result} -> result end)

    1..75
    |> Enum.reduce(input, fn step, acc ->
      IO.inspect(step, label: "input")

      acc
      |> Enum.flat_map(fn
        current when current < 10 and step > 35 ->
          [{:calced, Enum.at(map, current) |> Enum.at(75 - step)}]

        current ->
          transform(current)
      end)
    end)
    |> Enum.map(fn
      {:calced, v} -> v
      _ -> 1
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  # defp find_cycle(current, members, unprocessed) do
  #   if MapSet.member?(members, current) do
  #     {members, unprocessed}
  #   else
  #     updated_members = MapSet.put(members, current)

  #     case transform(current) do
  #       [f, s] -> find_cycle(f, updated_members, [s | unprocessed])
  #       [single] -> find_cycle(single, updated_members, unprocessed)
  #     end
  #   end
  # end

  defp transform({:calced, v}), do: [{:calced, v}]

  defp transform(0), do: [1]

  defp transform(n) do
    digits = Integer.digits(n)
    size = length(digits)

    case rem(size, 2) do
      0 ->
        {f, s} = Enum.split(digits, div(size, 2))
        [Integer.undigits(f), Integer.undigits(s)]

      _ ->
        [n * 2024]
    end
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split([" ", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
