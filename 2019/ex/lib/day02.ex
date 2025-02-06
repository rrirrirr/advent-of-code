defmodule Day02 do
  def part_1(file) do
    input = get_input(file) |> List.replace_at(1, 12) |> List.replace_at(2, 2)

    process(input, 0)
    |> hd()
    |> IO.inspect()
  end

  def part_2(file) do
    input = get_input(file)

    vs = for x <- 0..99, y <- 0..99, do: [x, y]

    vs
    |> Enum.find(fn [a, b] ->
      input = input |> List.replace_at(1, a) |> List.replace_at(2, b)

      v =
        process(input, 0)
        |> hd()

      IO.inspect(v, label: "#{a}, #{b}")
      v == 19_690_720
    end)
    |> then(fn [a, b] -> 100 * a + b end)
    |> IO.inspect()
  end

  def permutations([]), do: [[]]

  def permutations(list) do
    for x <- list,
        y <- permutations(list -- [x]),
        do: [x | y]
  end

  defp process(p, pos) do
    opcode = Enum.at(p, pos)

    case opcode do
      1 ->
        p1 = Enum.at(p, pos + 1)
        p2 = Enum.at(p, pos + 2)
        a1 = Enum.at(p, p1)
        a2 = Enum.at(p, p2)
        d = Enum.at(p, pos + 3)
        p = List.replace_at(p, d, a1 + a2)
        process(p, pos + 4)

      2 ->
        p1 = Enum.at(p, pos + 1)
        p2 = Enum.at(p, pos + 2)
        a1 = Enum.at(p, p1)
        a2 = Enum.at(p, p2)
        d = Enum.at(p, pos + 3)
        p = List.replace_at(p, d, a1 * a2)
        process(p, pos + 4)

      99 ->
        p
    end
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
