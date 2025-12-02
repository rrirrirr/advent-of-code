defmodule Day02 do
  def part_1(file) do
    get_input(file)
    |> Stream.flat_map(&get_ranges/1)
    |> Enum.filter(&is_invalid_id/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(file) do
    get_input(file)
    |> Stream.flat_map(&get_ranges/1)
    |> Enum.filter(&is_invalid_id_2/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp get_ranges([from, to]) do
    Enum.to_list(from..to)
  end

  defp is_invalid_id(num) do
    string = Integer.to_string(num)
    id_length = String.length(string)

    if rem(id_length, 2) != 0 do
      false
    else
      middle = div(id_length, 2)
      {first, last} = String.split_at(string, middle)
      first == last
    end
  end

  defp is_invalid_id_2(num) do
    string = Integer.to_string(num)
    rec_find(string, "")
  end

  defp rec_find(<<>>, _), do: false

  defp rec_find(<<head::binary-size(1), rest::binary>>, acc) do
    pattern = acc <> head
    pattern_len = String.length(pattern)
    rest_len = String.length(rest)

    cond do
      pattern_len > rest_len ->
        false

      true ->
        parts =
          String.split(rest, pattern, trim: true)

        if length(parts) == 0 do
          true
        else
          rec_find(rest, pattern)
        end
    end
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n", ",", "-"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
  end
end
