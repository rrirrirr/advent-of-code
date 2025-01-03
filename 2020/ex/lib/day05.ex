defmodule Day05 do
  def part_1(file) do
    get_input(file)
    |> Enum.map(fn line ->
      String.graphemes(line)
      |> Enum.reduce({0, 127, 0, 7}, fn char, {rs, re, cs, ce} ->
        case char do
          "F" ->
            half = div(re - rs + 1, 2)
            {rs, re - half, cs, ce}

          "B" ->
            half = div(re - rs + 1, 2)
            {rs + half, re, cs, ce}

          "L" ->
            half = div(ce - cs + 1, 2)
            {rs, re, cs, ce - half}

          "R" ->
            half = div(ce - cs + 1, 2)
            {rs, re, cs + half, ce}
        end
      end)
      |> then(fn {row, _, col, _} -> row * 8 + col end)
    end)
    |> Enum.max()
    |> IO.inspect()
  end

  def part_2(file) do
    ids =
      get_input(file)
      |> Enum.map(fn line ->
        String.graphemes(line)
        |> Enum.reduce({0, 127, 0, 7}, fn char, {rs, re, cs, ce} ->
          case char do
            "F" ->
              half = div(re - rs + 1, 2)
              {rs, re - half, cs, ce}

            "B" ->
              half = div(re - rs + 1, 2)
              {rs + half, re, cs, ce}

            "L" ->
              half = div(ce - cs + 1, 2)
              {rs, re, cs, ce - half}

            "R" ->
              half = div(ce - cs + 1, 2)
              {rs, re, cs + half, ce}
          end
        end)
        |> then(fn {row, _, col, _} -> row * 8 + col end)
      end)

    {min_, max_} = ids |> Enum.min_max()

    possible = MapSet.new(min_..max_)

    MapSet.difference(possible, MapSet.new(ids))
    |> IO.inspect()
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
  end
end
