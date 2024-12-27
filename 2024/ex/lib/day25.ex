defmodule Day25 do
  def part_1(file) do
    input = get_input(file)

    locks =
      input
      |> Enum.filter(&Enum.all?(hd(&1), fn c -> c == "#" end))

    pins =
      input
      |> Enum.filter(&Enum.any?(hd(&1), fn c -> c == "." end))

    lock_heights =
      locks
      |> Enum.map(fn lock ->
        lock
        |> Enum.zip()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(fn col ->
          col |> Enum.count(fn c -> c == "#" end)
        end)
      end)

    pin_heights =
      pins
      |> Enum.map(fn pin ->
        pin
        |> Enum.zip()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(fn col ->
          col |> Enum.count(fn c -> c == "#" end)
        end)
      end)

    lock_heights
    |> Enum.reduce({0, pin_heights}, fn lock, {found, pins_left} ->
      matches = Enum.count(pins_left, fn pin -> is_a_match(lock, pin) end)
      {found + matches, pins_left}
    end)
    |> elem(0)
    |> IO.inspect()
  end

  defp is_a_match(lock, pin) do
    Enum.zip(lock, pin) |> Enum.all?(fn {l, p} -> l + p < 8 end)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn chunk ->
      String.split(chunk, "\n", trim: true)
      |> Enum.map(&String.graphemes/1)
    end)
  end
end
