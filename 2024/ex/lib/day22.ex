defmodule Day22 do
  require Bitwise

  def part_1(file) do
    get_input(file)
    |> Enum.map(&process_secret_num(&1, 2000))
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(file) do
    l =
      get_input(file)
      |> Enum.map(&process_prices(&1, 2000))

    l
    |> Enum.with_index()
    |> Enum.reduce(
      %{},
      fn {list_of_windows, idx}, window_map ->
        Enum.reduce(list_of_windows, window_map, fn {_, p, _, window}, acc ->
          cond do
            Map.has_key?(acc, [idx] ++ window) == true ->
              acc

            true ->
              Map.put(acc, [idx] ++ window, 0)
              |> Map.update(window, p, fn total -> p + total end)
          end
        end)
      end
    )
    |> Map.values()
    |> Enum.max()
    |> IO.inspect(charlists: :as_lists)
  end

  defp process_prices(num, steps) do
    1..steps
    |> Enum.reduce(
      [{num, rem(num, 10), 0, [rem(num, 10), -100, -100, -100]}],
      fn _, [{secret_num, price, _, [w1, w2, w3, _]} | _] = acc ->
        step1 =
          (secret_num * 64)
          |> mix(secret_num)
          |> prune()

        step2 =
          div(step1, 32)
          |> mix(step1)
          |> prune()

        step3 =
          (step2 * 2048)
          |> mix(step2)
          |> prune()

        new_price = rem(step3, 10)
        change = new_price - price

        new_window = [change, w1, w2, w3]
        [{step3, new_price, change, new_window} | acc]
      end
    )
    |> Enum.reverse()
  end

  defp process_secret_num(num, steps) do
    1..steps
    |> Enum.reduce(num, fn _, secret_num ->
      step1 =
        (secret_num * 64)
        |> mix(secret_num)
        |> prune()

      step2 =
        div(step1, 32)
        |> mix(step1)
        |> prune()

      (step2 * 2048)
      |> mix(step2)
      |> prune()
    end)
  end

  defp mix(num, secret_num), do: Bitwise.bxor(num, secret_num)
  defp prune(num), do: rem(num, 16_777_216)

  defp get_input(file) do
    File.read!(file) |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
  end
end
