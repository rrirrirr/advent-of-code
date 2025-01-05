defmodule Day09 do
  def part_1(file) do
    input = get_input(file)

    input
    |> Enum.reduce_while({[], []}, fn num, {sums, prev} ->
      if is_summable(num, sums) or length(prev) < 25 do
        sums =
          case length(sums) do
            625 ->
              Enum.drop(sums, 25) ++ Enum.map(prev, fn n -> n + num end)

            _ ->
              sums ++ Enum.map(prev, fn n -> n + num end)
          end

        prev =
          case length(prev) do
            25 ->
              tl(prev) ++ [num]

            _ ->
              prev ++ [num]
          end

        {:cont, {sums, prev}}
      else
        {:halt, num}
      end
    end)
    |> IO.inspect()
  end

  def part_2(file) do
    input = get_input(file)
    err_num = part_1(file)

    find_cont(input, err_num)
    |> Enum.min_max()
    |> then(fn {mi, ma} -> mi + ma end)
    |> IO.inspect()
  end

  defp find_cont(l, t) do
    [_ | rest] = l
    res = is_cont(l, 0, t, [])

    if res != false do
      res
    else
      find_cont(rest, t)
    end
  end

  defp is_cont([num | rest], current_sum, sum_to_reach, members) do
    new_sum =
      current_sum + num

    cond do
      new_sum < sum_to_reach ->
        is_cont(rest, new_sum, sum_to_reach, [num] ++ members)

      new_sum > sum_to_reach ->
        false

      true ->
        [num] ++ members
    end
  end

  defp is_summable(num, sums) do
    Enum.member?(sums, num)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
