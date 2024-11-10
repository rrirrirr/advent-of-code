defmodule Day03 do
  def part1(file) do
    list =
      file
      |> File.read!()
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.graphemes/1)

    gamma =
      List.zip(list)
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.frequencies/1)
      |> Enum.map(&Map.to_list/1)
      |> Enum.map(fn [{"0", count0}, {"1", count1}] -> if count0 > count1, do: "0", else: "1" end)
      |> Enum.join()
      |> String.to_integer(2)

    epsilon =
      gamma
      |> Integer.to_string(2)
      |> String.graphemes()
      |> Enum.map(fn
        "1" -> "0"
        "0" -> "1"
      end)
      |> Enum.join()
      |> String.to_integer(2)

    gamma * epsilon
  end

  def part2(file) do
    list =
      file
      |> File.read!()
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.graphemes/1)

    transposedList = List.zip(list) |> Enum.map(&Tuple.to_list/1)

    co2 =
      transposedList
      |> Enum.reduce({[], []}, fn row, {bits, toFilter} ->
        filtered =
          row
          |> Enum.with_index()
          |> Enum.filter(fn {_, idx} -> not Enum.member?(toFilter, idx) end)
          |> Enum.map(fn {val, _} -> val end)

        leastCommon =
          filtered
          |> Enum.frequencies()
          |> then(fn
            %{"0" => count0, "1" => count1} -> if count0 <= count1, do: "0", else: "1"
            %{"0" => _count} -> "0"
            %{"1" => _count} -> "1"
            %{} -> "0"
          end)

        mostCommon = if leastCommon == "1", do: "0", else: "1"

        toFilterNext =
          row
          |> Enum.with_index()
          |> Enum.filter(fn {value, _index} -> value == mostCommon end)
          |> Enum.map(fn {_, index} -> index end)
          |> Enum.filter(&(not Enum.member?(toFilter, &1)))

        {bits ++ [leastCommon], toFilter ++ toFilterNext}
      end)
      |> elem(0)
      |> Enum.join("")
      |> String.to_integer(2)

    oxygen =
      transposedList
      |> Enum.reduce({[], []}, fn row, {bits, toFilter} ->
        filtered =
          row
          |> Enum.with_index()
          |> Enum.filter(fn {_, idx} -> not Enum.member?(toFilter, idx) end)
          |> Enum.map(fn {val, _} -> val end)

        leastCommon =
          filtered
          |> Enum.frequencies()
          |> then(fn
            %{"0" => count0, "1" => count1} -> if count1 < count0, do: "1", else: "0"
            %{"0" => _count} -> "1"
            %{"1" => _count} -> "0"
            %{} -> "1"
          end)

        mostCommon = if leastCommon == "1", do: "0", else: "1"

        toFilterNext =
          row
          |> Enum.with_index()
          |> Enum.filter(fn {value, _index} -> value == leastCommon end)
          |> Enum.map(fn {_, index} -> index end)
          |> Enum.filter(&(not Enum.member?(toFilter, &1)))

        {bits ++ [mostCommon], toFilter ++ toFilterNext}
      end)
      |> elem(0)
      |> Enum.join("")
      |> String.to_integer(2)

    oxygen * co2
  end
end
