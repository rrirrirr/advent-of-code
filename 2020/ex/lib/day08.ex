defmodule Day08 do
  def part_1(file) do
    input = get_input(file)

    process(input, 0, Enum.at(input, 0), 0, %{}, 0)
    |> List.flatten()
    |> Enum.filter(&(&1 != false))
    |> IO.inspect()
  end

  def part_2(file) do
    part_1(file)
  end

  def process(_instructions, _pos, nil, _, _seen, _) do
    false
  end

  def process(_instructions, _pos, {"stop", _, _}, acc, _seen, _) do
    IO.inspect("hit")

    acc
  end

  def process(instructions, pos, {"nop", "+", v}, acc, seen, changed) do
    cond do
      changed == 1 ->
        seen = Map.put(seen, pos, true)
        process(instructions, pos + 1, Enum.at(instructions, pos + 1), acc, seen, changed)

      true ->
        seen = Map.put(seen, pos, true)

        [
          process(instructions, pos + 1, Enum.at(instructions, pos + 1), acc, seen, changed),
          process(
            List.replace_at(instructions, pos, {"jmp", "+", v}),
            pos + v,
            Enum.at(instructions, pos + v),
            acc,
            seen,
            1
          )
        ]
    end
  end

  def process(instructions, pos, {"nop", "-", v}, acc, seen, changed) do
    cond do
      changed == 1 ->
        seen = Map.put(seen, pos, true)
        process(instructions, pos + 1, Enum.at(instructions, pos + 1), acc, seen, changed)

      true ->
        seen = Map.put(seen, pos, true)

        [
          process(instructions, pos + 1, Enum.at(instructions, pos + 1), acc, seen, changed),
          process(
            List.replace_at(instructions, pos, {"jmp", "-", v}),
            pos - v,
            Enum.at(instructions, pos - v),
            acc,
            seen,
            1
          )
        ]
    end
  end

  def process(instructions, pos, {"acc", "+", v}, acc, seen, changed) do
    seen = Map.put(seen, pos, true)
    process(instructions, pos + 1, Enum.at(instructions, pos + 1), acc + v, seen, changed)
  end

  def process(instructions, pos, {"acc", "-", v}, acc, seen, changed) do
    seen = Map.put(seen, pos, true)
    process(instructions, pos + 1, Enum.at(instructions, pos + 1), acc - v, seen, changed)
  end

  def process(instructions, pos, {"jmp", "+", v}, acc, seen, changed) do
    cond do
      Map.has_key?(seen, pos) ->
        false

      changed == 1 ->
        seen = Map.put(seen, pos, true)
        process(instructions, pos + v, Enum.at(instructions, pos + v), acc, seen, changed)

      true ->
        seen = Map.put(seen, pos, true)

        [
          process(instructions, pos + v, Enum.at(instructions, pos + v), acc, seen, changed),
          process(
            List.replace_at(instructions, pos, {"nop", "-", v}),
            pos + 1,
            Enum.at(instructions, pos + 1),
            acc,
            seen,
            1
          )
        ]
    end
  end

  def process(instructions, pos, {"jmp", "-", v}, acc, seen, changed) do
    cond do
      Map.has_key?(seen, pos) ->
        false

      changed == 1 ->
        seen = Map.put(seen, pos, true)
        process(instructions, pos - v, Enum.at(instructions, pos - v), acc, seen, changed)

      true ->
        seen = Map.put(seen, pos, true)

        [
          process(instructions, pos - v, Enum.at(instructions, pos - v), acc, seen, changed),
          process(
            List.replace_at(instructions, pos, {"nop", "-", v}),
            pos + 1,
            Enum.at(instructions, pos + 1),
            acc,
            seen,
            1
          )
        ]
    end
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn row ->
      [c, rest] = String.split(row, " ", trim: true)
      <<op::binary-size(1)>> <> num = rest
      {c, op, String.to_integer(num)}
    end)
  end
end
