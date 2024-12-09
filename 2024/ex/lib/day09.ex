defmodule Day09 do
  def part_1(file) do
    get_input(file)
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.flat_map(&expand(&1))
    |> then(fn list ->
      max_l = list |> Enum.reject(&(&1 == ".")) |> length()
      move_blocks(list, Enum.reverse(list), [], max_l)
    end)
    |> Enum.with_index()
    |> Enum.map(fn {v, idx} -> v * idx end)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(file) do
    get_input(file)
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.flat_map(&parse_space/1)
    |> then(fn l ->
      move_full_blocks(l, [])
    end)
    |> Enum.with_index()
    |> Enum.map(fn
      {".", _} -> 0
      {v, idx} -> v * idx
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp parse_space({[files], id}) do
    [{id, files}]
  end

  defp parse_space({[files, 0], id}) do
    [{id, files}]
  end

  defp parse_space({[files, free_space], id}) do
    [
      {id, files},
      {:free, free_space}
    ]
  end

  defp move_full_blocks([], right), do: right

  defp move_full_blocks(left, right) do
    IO.inspect(length(left))

    case List.last(left) do
      {:free, l} ->
        move_full_blocks(Enum.drop(left, -1), exp({:free, l}) ++ right)

      {id, l} ->
        updated_list = place_block(List.replace_at(left, -1, {:free, l}), [], {id, l})
        last = List.last(updated_list)
        move_full_blocks(Enum.drop(updated_list, -1), exp(last) ++ right)
    end
  end

  defp exp({:free, l}), do: List.duplicate(".", l)
  defp exp({id, l}), do: List.duplicate(id, l)

  defp place_block([], left, block) do
    left ++ [block]
  end

  defp place_block([{:free, space} | rest], left, {id, len}) when len == space do
    left ++ [{id, len}] ++ rest
  end

  defp place_block([{:free, space} | rest], left, {id, len}) when len < space do
    left ++ [{id, len}, {:free, space - len}] ++ rest
  end

  defp place_block([block | rest], left, {id, len}) do
    place_block(rest, left ++ [block], {id, len})
  end

  defp move_blocks(_, _, acc, l) when length(acc) == l, do: acc

  defp move_blocks([], _, acc, _), do: acc

  defp move_blocks(["." | rest], [n | rev_rest], acc, l) do
    move_blocks([n | rest], rev_rest, acc, l)
  end

  defp move_blocks([n | rest], reversed, acc, l) do
    move_blocks(rest, reversed, acc ++ [n], l)
  end

  defp expand({[files], id}) do
    List.duplicate(id, files)
  end

  defp expand({[files, free_space], id}) do
    List.duplicate(id, files) ++ List.duplicate(".", free_space)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end
end
