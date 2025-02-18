defmodule Day05 do
  def part_1(file) do
    input = get_input(file)
    # ID 1 for air conditioner unit
    process(input, 0, 1)
  end

  def part_2(file) do
    input = get_input(file)
    # ID 5 for thermal radiator controller
    process(input, 0, 5)
  end

  defp process(p, pos, id) do
    {_m3, m2, m1, opcode} = process_code(Enum.at(p, pos))

    case opcode do
      1 ->
        p1 = get_param(p, m1, pos + 1)
        p2 = get_param(p, m2, pos + 2)
        d = Enum.at(p, pos + 3)
        p = List.replace_at(p, d, p1 + p2)
        process(p, pos + 4, id)

      2 ->
        p1 = get_param(p, m1, pos + 1)
        p2 = get_param(p, m2, pos + 2)
        d = Enum.at(p, pos + 3)
        p = List.replace_at(p, d, p1 * p2)
        process(p, pos + 4, id)

      3 ->
        d = Enum.at(p, pos + 1)
        p = List.replace_at(p, d, id)
        process(p, pos + 2, id)

      4 ->
        p1 = get_param(p, m1, pos + 1)
        IO.puts(p1)
        process(p, pos + 2, id)

      5 ->
        p1 = get_param(p, m1, pos + 1)

        if p1 > 0 do
          p2 = get_param(p, m2, pos + 2)
          process(p, p2, id)
        else
          process(p, pos + 3, id)
        end

      6 ->
        p1 = get_param(p, m1, pos + 1)

        if p1 == 0 do
          p2 = get_param(p, m2, pos + 2)
          process(p, p2, id)
        else
          process(p, pos + 3, id)
        end

      7 ->
        p1 = get_param(p, m1, pos + 1)
        p2 = get_param(p, m2, pos + 2)
        d = Enum.at(p, pos + 3)

        if p1 < p2 do
          p = List.replace_at(p, d, 1)
          process(p, pos + 4, id)
        else
          p = List.replace_at(p, d, 0)
          process(p, pos + 4, id)
        end

      8 ->
        p1 = get_param(p, m1, pos + 1)
        p2 = get_param(p, m2, pos + 2)
        d = Enum.at(p, pos + 3)

        if p1 == p2 do
          p = List.replace_at(p, d, 1)
          process(p, pos + 4, id)
        else
          p = List.replace_at(p, d, 0)
          process(p, pos + 4, id)
        end

      99 ->
        p
    end
  end

  defp get_param(p, :position, pos), do: Enum.at(p, Enum.at(p, pos))
  defp get_param(p, :immediate, pos), do: Enum.at(p, pos)

  defp process_code(code) do
    # if code is shorter than 5 digits we should add 0 before
    padded = Integer.digits(code) |> then(fn d -> List.duplicate(0, 5 - length(d)) ++ d end)
    # opcode is the two last digits
    opcode = padded |> Enum.take(-2) |> Integer.undigits()

    # looking at 3 first positions to decide if they are position or immediate params
    [p3, p2, p1] =
      padded
      |> Enum.take(3)
      |> Enum.map(fn
        0 -> :position
        1 -> :immediate
      end)

    {p3, p2, p1, opcode}
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
