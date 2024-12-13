defmodule Day13 do
  def part_1(file) do
    get_input(file)
    |> Enum.map(fn [a, b, p] ->
      case get_most_expensive_button(a, b) do
        :a -> press_buttons(a ++ [3], b ++ [1], p)
        :b -> press_buttons(b ++ [1], a ++ [3], p)
      end
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(file) do
    get_input(file)
    |> Enum.map(fn [a, b, [px, py]] ->
      [a, b, [px + 10_000_000_000_000, py + 10_000_000_000_000]]
    end)
    |> Enum.map(fn [a, b, p] ->
      find_solutions(a ++ [3], b ++ [1], p)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp find_solutions([ax, ay, acost], [bx, by, bcost], [target_x, target_y]) do
    det = ax * by - bx * ay

    m = (by * target_x - bx * target_y) / det
    n = (-ay * target_x + ax * target_y) / det

    is_int = fn x ->
      Float.round(x) == x
    end

    if m >= 0 and n >= 0 and
         is_int.(m) and is_int.(n) do
      trunc(m * acost) + trunc(n * bcost)
    else
      0
    end
  end

  defp press_buttons([ax, ay, acost], [bx, by, bcost], [prize_x, prize_y]) do
    1..max(prize_x, prize_y)
    |> Enum.reduce_while({0, 0, 0}, fn _, {cx, cy, cp} ->
      cond do
        cx > prize_x or cy > prize_y ->
          {:halt, 0}

        rem(prize_x - cx, bx) == 0 and rem(prize_y - cy, by) == 0 and
            div(prize_x - cx, bx) == div(prize_y - cy, by) ->
          {:halt, cp + div(prize_x - cx, bx) * bcost}

        true ->
          IO.inspect(rem(prize_x - cx, bx), label: "rem x")
          IO.inspect(rem(prize_y - cy, by), label: "rem y")

          {:cont, {cx + ax, cy + ay, cp + acost}}
      end
    end)
  end

  defp get_most_expensive_button([ax, ay], [bx, by]) do
    a_cost = (ax + ay) / 3
    b_cost = bx + by
    if a_cost < b_cost, do: :a, else: :b
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn p ->
      String.split(p, ["\n", "Button A: ", ", ", "Button B: ", "Prize: ", "X+", "Y+", "X=", "Y="],
        trim: true
      )
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
    end)
  end
end
