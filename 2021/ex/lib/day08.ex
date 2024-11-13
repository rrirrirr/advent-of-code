defmodule Day08 do
  def part_1(file) do
    input = get_input(file)

    to_look_for = MapSet.new([2, 3, 4, 7])

    input
    |> Enum.map(fn [_pre, output] ->
      output
      |> Enum.map(&String.length/1)
      |> Enum.count(&MapSet.member?(to_look_for, &1))
    end)
    |> Enum.sum()
  end

  def part_2(file) do
    input = get_input(file)

    digit_positions =
      List.duplicate(
        Enum.to_list(?a..?g) |> List.to_string() |> String.graphemes(),
        7
      )

    input
    |> Enum.map(fn [pre, output] -> {pre ++ output, output} end)
    |> Enum.map(fn {line, output} ->
      mapping =
        line
        |> Enum.map(fn str -> {str, String.length(str)} end)
        |> Enum.sort_by(fn {_str, length} -> length end)
        |> Enum.map(fn {str, _length} -> str end)
        |> Enum.reduce(digit_positions, fn str, positions ->
          filter_digit_position(positions, str)
        end)
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {chars, idx}, acc ->
          Enum.reduce(chars, acc, fn char, inner_acc ->
            Map.put(inner_acc, char, idx)
          end)
        end)

      output
      |> Enum.map(fn str ->
        str
        |> String.graphemes()
        |> Enum.map(&Map.get(mapping, &1))
        |> Enum.sort()
        |> get_digit()
      end)
      |> Enum.join("")
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  defp get_digit([1, 2]), do: "1"
  defp get_digit([0, 1, 3, 4, 6]), do: "2"
  defp get_digit([0, 1, 2, 3, 6]), do: "3"
  defp get_digit([1, 2, 5, 6]), do: "4"
  defp get_digit([0, 2, 3, 5, 6]), do: "5"
  defp get_digit([0, 2, 3, 4, 5, 6]), do: "6"
  defp get_digit([0, 1, 2]), do: "7"
  defp get_digit([0, 1, 2, 3, 4, 5, 6]), do: "8"
  defp get_digit([0, 1, 2, 3, 5, 6]), do: "9"
  defp get_digit([0, 1, 2, 3, 4, 5]), do: "0"

  defp filter_digit_position(current_chars, str) do
    positions_to_filter =
      case {String.length(str), str} do
        {2, _} ->
          [false, true, true, false, false, false, false]

        {3, _} ->
          [true, true, true, false, false, false, false]

        {4, _} ->
          [false, true, true, false, false, true, true]

        # We know a 3 is the only digit that contains same characters a one
        # we will use this to move forward
        {5, str} ->
          second_position_chars = Enum.at(current_chars, 1)

          all_chars_present =
            Enum.all?(second_position_chars, fn char ->
              String.contains?(str, char)
            end)

          if all_chars_present do
            [true, true, true, true, false, false, true]
          else
            false
          end

        # We will look for a 6 here since it only contains one of the chars in a 1 and should solve the problem
        {6, _} ->
          second_position_chars = Enum.at(current_chars, 1)

          all_chars_present =
            Enum.all?(second_position_chars, fn char ->
              String.contains?(str, char)
            end)

          if not all_chars_present do
            [true, false, true, true, true, true, true]
          else
            false
          end

        {7, _} ->
          false

        {_, _} ->
          false
      end

    filter_position(current_chars, positions_to_filter, str)
  end

  defp filter_position(current_chars, false, _str) do
    current_chars
  end

  defp filter_position(current_chars, positions_to_filter, str) do
    current_chars
    |> Enum.with_index()
    |> Enum.map(fn {value, idx} ->
      if Enum.at(positions_to_filter, idx) do
        Enum.filter(value, &String.contains?(str, &1))
      else
        Enum.filter(value, &(not String.contains?(str, &1)))
      end
    end)
  end

  def get_input(file) do
    File.read!(file)
    |> String.split(["|", "\n"])
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn x ->
      String.split(x, " ") |> Enum.filter(&(&1 != ""))
    end)
    |> Enum.chunk_every(2)
  end
end
