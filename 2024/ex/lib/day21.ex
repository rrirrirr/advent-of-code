defmodule Day21 do
  def part_1(file) do
    codes =
      get_input(file)

    codes
    |> Enum.map(&type_code(&1, "A"))
    |> Enum.map(fn possible ->
      possible
      |> Enum.flat_map(&type_code_arrow(&1, :press))
      |> tap(&IO.inspect(Enum.count(&1), label: "Count"))
      |> Enum.with_index()
      |> Task.async_stream(
        fn {list, idx} ->
          IO.inspect("#{idx}")

          type_code_arrow_len(list, :press)
          |> Enum.min()

          # |> IO.inspect()
        end,
        timeout: :infinity,
        ordered: false,
        max_concurrency: System.schedulers_online()
      )
      |> Stream.map(fn {:ok, result} ->
        result
      end)
      |> Enum.to_list()
      |> Enum.min()
    end)
    |> Enum.zip(codes)
    |> Enum.reduce(0, fn {key_presses, code}, total ->
      code_value =
        code
        |> Enum.take_while(&(&1 != "A"))
        |> Enum.join("")
        |> String.to_integer()

      IO.inspect("#{code} #{key_presses}")
      total + key_presses * code_value
    end)
    |> IO.inspect()
  end

  def part_2(file) do
    codes =
      get_input(file)

    codes
    |> Enum.reduce({0, %{}}, fn code, {total, cache} ->
      num =
        code
        |> Enum.take_while(&(&1 != "A"))
        |> Enum.join("")
        |> String.to_integer()

      {min_length, updated_cache} =
        type_code(code, "A")
        |> Enum.reduce({:no_min, cache}, fn sequence, {min_, curr_cache} ->
          {seq_total, new_cache} = min_seq(sequence, 25, curr_cache)

          cond do
            min_ == :no_min -> {seq_total, new_cache}
            true -> {min(min_, seq_total), new_cache}
          end
        end)

      {total + num * min_length, updated_cache}
    end)
    |> elem(0)
    |> IO.inspect()
  end

  defp min_seq(keys, depth, cache) do
    cache_key = {Enum.join(keys), depth}

    cond do
      depth == 0 ->
        {length(keys), cache}

      Map.has_key?(cache, cache_key) ->
        {Map.get(cache, cache_key), cache}

      true ->
        {total, new_cache} =
          keys
          |> Enum.chunk_by(fn x -> x == :press end)
          |> Enum.chunk_every(2)
          |> Enum.map(&List.flatten/1)
          |> Enum.map(&type_code_arrow(&1, :press))
          |> Enum.reduce({0, cache}, fn sequences, {total, current_cache} ->
            {min_, updated_cache} =
              sequences
              |> Enum.reduce({:no_min, current_cache}, fn sequence, {min_, cache_acc} ->
                {s, new_cache} = min_seq(sequence, depth - 1, cache_acc)

                min_value =
                  cond do
                    min_ == :no_min -> s
                    true -> min(min_, s)
                  end

                {min_value, new_cache}
              end)

            {total + min_, updated_cache}
          end)

        final_cache = Map.put(new_cache, cache_key, total)
        {total, final_cache}
    end
  end

  defp type_code(chars, state, pre \\ [])
  defp type_code([], _state, path), do: [path]

  defp type_code([n | rest], state1, pre) do
    {paths, new_state} = numeric(state1, n)

    paths
    |> Enum.flat_map(fn path ->
      type_code(rest, new_state, pre ++ path)
    end)
  end

  defp type_code_arrow(chars, state, pre \\ [])
  defp type_code_arrow([], _, path), do: [path]

  defp type_code_arrow([n | rest], state1, pre) do
    {paths, new_state} = directional(state1, n)

    paths
    |> Enum.flat_map(fn path ->
      type_code_arrow(rest, new_state, pre ++ path)
    end)
  end

  defp type_code_arrow_len(chars, state, pre \\ [])
  defp type_code_arrow_len([], _, path), do: [length(path)]

  defp type_code_arrow_len([n | rest], state1, pre) do
    {paths, new_state} = directional(state1, n)

    paths
    |> Enum.flat_map(fn path ->
      type_code_arrow_len(rest, new_state, pre ++ path)
    end)
  end

  # Arrow pad layout:
  #     +---+---+
  #     | ^ | A |
  # +---+---+---+
  # | < | v | > |
  # +---+---+---+

  # From up arrow (^)
  defp directional(:up, :up), do: {[[:press]], :up}
  defp directional(:up, :down), do: {[[:down, :press]], :down}
  defp directional(:up, :left), do: {[[:down, :left, :press]], :left}
  defp directional(:up, :press), do: {[[:right, :press]], :press}

  defp directional(:up, :right),
    do:
      {[
         [:down, :right, :press],
         [:right, :down, :press]
       ], :right}

  # From down arrow (v)
  defp directional(:down, :up), do: {[[:up, :press]], :up}
  defp directional(:down, :down), do: {[[:press]], :down}
  defp directional(:down, :left), do: {[[:left, :press]], :left}
  defp directional(:down, :right), do: {[[:right, :press]], :right}

  defp directional(:down, :press),
    do:
      {[
         [:up, :right, :press],
         [:right, :up, :press]
       ], :press}

  # From left arrow (<)
  defp directional(:left, :up), do: {[[:right, :up, :press]], :up}
  defp directional(:left, :down), do: {[[:right, :press]], :down}
  defp directional(:left, :left), do: {[[:press]], :left}
  defp directional(:left, :right), do: {[[:right, :right, :press]], :right}

  defp directional(:left, :press),
    do:
      {[
         # [:right, :up, :right, :press],
         [:right, :right, :up, :press]
       ], :press}

  # From right arrow (>)
  defp directional(:right, :up),
    do:
      {[
         [:left, :up, :press],
         [:up, :left, :press]
       ], :up}

  defp directional(:right, :down), do: {[[:left, :press]], :down}
  defp directional(:right, :left), do: {[[:left, :left, :press]], :left}
  defp directional(:right, :right), do: {[[:press]], :right}
  defp directional(:right, :press), do: {[[:up, :press]], :press}

  # From press position (A)
  defp directional(:press, :up), do: {[[:left, :press]], :up}

  defp directional(:press, :down),
    do:
      {[
         [:left, :down, :press],
         [:down, :left, :press]
       ], :down}

  defp directional(:press, :left),
    do:
      {[
         [:down, :left, :left, :press]
         # [:left, :down, :left, :press]
       ], :left}

  defp directional(:press, :right), do: {[[:down, :press]], :right}
  defp directional(:press, :press), do: {[[:press]], :press}

  # +---+---+---+
  # | 7 | 8 | 9 |
  # +---+---+---+
  # | 4 | 5 | 6 |
  # +---+---+---+
  # | 1 | 2 | 3 |
  # +---+---+---+
  #     | 0 | A |
  #     +---+---+

  # From "0"
  defp numeric("0", "0"), do: {[[:press]], "0"}
  defp numeric("0", "A"), do: {[[:right, :press]], "A"}
  defp numeric("0", "1"), do: {[[:up, :left, :press]], "1"}
  defp numeric("0", "2"), do: {[[:up, :press]], "2"}
  defp numeric("0", "3"), do: {[[:up, :right, :press], [:right, :up, :press]], "3"}

  defp numeric("0", "4"),
    do:
      {[
         [:up, :up, :left, :press]
         # [:up, :left, :up, :press]
       ], "4"}

  defp numeric("0", "5"), do: {[[:up, :up, :press]], "5"}

  defp numeric("0", "6"),
    do:
      {[
         [:up, :up, :right, :press],
         # [:up, :right, :up, :press],
         [:right, :up, :up, :press]
       ], "6"}

  defp numeric("0", "7"),
    do:
      {[
         [:up, :up, :up, :left, :press]
         # [:up, :up, :left, :up, :press],
         # [:up, :left, :up, :up, :press]
       ], "7"}

  defp numeric("0", "8"), do: {[[:up, :up, :up, :press]], "8"}

  defp numeric("0", "9"),
    do:
      {[
         [:up, :up, :up, :right, :press],
         # [:up, :up, :right, :up, :press],
         # [:up, :right, :up, :up, :press],
         [:right, :up, :up, :up, :press]
       ], "9"}

  # From "A"
  defp numeric("A", "0"), do: {[[:left, :press]], "0"}
  defp numeric("A", "A"), do: {[[:press]], "A"}

  defp numeric("A", "1"),
    do:
      {[
         [:up, :left, :left, :press]
         # [:left, :up, :left, :press]
       ], "1"}

  defp numeric("A", "2"), do: {[[:up, :left, :press], [:left, :up, :press]], "2"}
  defp numeric("A", "3"), do: {[[:up, :press]], "3"}

  defp numeric("A", "4"),
    do:
      {[
         [:up, :up, :left, :left, :press]
         # [:up, :left, :up, :left, :press],
         # [:up, :left, :left, :up, :press]
         # [:left, :up, :up, :left, :press]
         # [:left, :up, :left, :up, :press]
       ], "4"}

  defp numeric("A", "5"),
    do:
      {[
         [:up, :up, :left, :press],
         # [:up, :left, :up, :press],
         [:left, :up, :up, :press]
       ], "5"}

  defp numeric("A", "6"), do: {[[:up, :up, :press]], "6"}

  defp numeric("A", "7"),
    do:
      {[
         [:up, :up, :up, :left, :left, :press]
         # [:up, :up, :left, :up, :left, :press],
         # [:up, :up, :left, :left, :up, :press],
         # [:up, :left, :up, :up, :left, :press],
         # [:up, :left, :up, :left, :up, :press],
         # [:up, :left, :left, :up, :up, :press],
         # [:left, :up, :up, :up, :left, :press]
         # [:left, :up, :up, :left, :up, :press],
         # [:left, :up, :left, :up, :up, :press]
       ], "7"}

  defp numeric("A", "8"),
    do:
      {[
         [:up, :up, :up, :left, :press],
         # [:up, :up, :left, :up, :press],
         # [:up, :left, :up, :up, :press],
         [:left, :up, :up, :up, :press]
       ], "8"}

  defp numeric("A", "9"), do: {[[:up, :up, :up, :press]], "9"}

  # From "1"
  defp numeric("1", "0"), do: {[[:right, :down, :press]], "0"}

  defp numeric("1", "A"),
    do:
      {[
         [:right, :right, :down, :press]
         # [:right, :down, :right, :press]
       ], "A"}

  defp numeric("1", "1"), do: {[[:press]], "1"}
  defp numeric("1", "2"), do: {[[:right, :press]], "2"}
  defp numeric("1", "3"), do: {[[:right, :right, :press]], "3"}
  defp numeric("1", "4"), do: {[[:up, :press]], "4"}

  defp numeric("1", "5"),
    do:
      {[
         [:up, :right, :press],
         [:right, :up, :press]
       ], "5"}

  defp numeric("1", "6"),
    do:
      {[
         [:up, :right, :right, :press],
         # [:right, :up, :right, :press],
         [:right, :right, :up, :press]
       ], "6"}

  defp numeric("1", "7"), do: {[[:up, :up, :press]], "7"}

  defp numeric("1", "8"),
    do:
      {[
         [:up, :up, :right, :press],
         # [:up, :right, :up, :press],
         [:right, :up, :up, :press]
       ], "8"}

  defp numeric("1", "9"),
    do:
      {[
         [:up, :up, :right, :right, :press],
         # [:up, :right, :up, :right, :press],
         # [:up, :right, :right, :up, :press],
         # [:right, :up, :up, :right, :press],
         # [:right, :up, :right, :up, :press],
         [:right, :right, :up, :up, :press]
       ], "9"}

  # From "2"
  defp numeric("2", "0"), do: {[[:down, :press]], "0"}

  defp numeric("2", "A"),
    do:
      {[
         [:down, :right, :press],
         [:right, :down, :press]
       ], "A"}

  defp numeric("2", "1"), do: {[[:left, :press]], "1"}
  defp numeric("2", "2"), do: {[[:press]], "2"}
  defp numeric("2", "3"), do: {[[:right, :press]], "3"}

  defp numeric("2", "4"),
    do:
      {[
         [:up, :left, :press],
         [:left, :up, :press]
       ], "4"}

  defp numeric("2", "5"), do: {[[:up, :press]], "5"}

  defp numeric("2", "6"),
    do:
      {[
         [:up, :right, :press],
         [:right, :up, :press]
       ], "6"}

  defp numeric("2", "7"),
    do:
      {[
         [:up, :up, :left, :press],
         # [:up, :left, :up, :press],
         [:left, :up, :up, :press]
       ], "7"}

  defp numeric("2", "8"), do: {[[:up, :up, :press]], "8"}

  defp numeric("2", "9"),
    do:
      {[
         [:up, :up, :right, :press],
         # [:up, :right, :up, :press],
         [:right, :up, :up, :press]
       ], "9"}

  # From "3"
  defp numeric("3", "0"),
    do:
      {[
         [:down, :left, :press],
         [:left, :down, :press]
       ], "0"}

  defp numeric("3", "A"), do: {[[:down, :press]], "A"}
  defp numeric("3", "1"), do: {[[:left, :left, :press]], "1"}
  defp numeric("3", "2"), do: {[[:left, :press]], "2"}
  defp numeric("3", "3"), do: {[[:press]], "3"}

  defp numeric("3", "4"),
    do:
      {[
         [:up, :left, :left, :press],
         # [:left, :up, :left, :press],
         [:left, :left, :up, :press]
       ], "4"}

  defp numeric("3", "5"),
    do:
      {[
         [:up, :left, :press],
         [:left, :up, :press]
       ], "5"}

  defp numeric("3", "6"), do: {[[:up, :press]], "6"}

  defp numeric("3", "7"),
    do:
      {[
         [:up, :up, :left, :left, :press],
         # [:up, :left, :up, :left, :press],
         # [:up, :left, :left, :up, :press],
         # [:left, :up, :up, :left, :press],
         # [:left, :up, :left, :up, :press],
         [:left, :left, :up, :up, :press]
       ], "7"}

  defp numeric("3", "8"),
    do:
      {[
         [:up, :up, :left, :press],
         # [:up, :left, :up, :press],
         [:left, :up, :up, :press]
       ], "8"}

  defp numeric("3", "9"), do: {[[:up, :up, :press]], "9"}

  # From "4"
  defp numeric("4", "0"),
    do:
      {[
         [:right, :down, :down, :press],
         [:down, :right, :down, :press]
       ], "0"}

  defp numeric("4", "A"),
    do:
      {[
         [:right, :right, :down, :down, :press]
         # [:right, :down, :right, :down, :press],
         # [:right, :down, :down, :right, :press],
         # [:down, :right, :right, :down, :press]
         # [:down, :right, :down, :right, :press]
       ], "A"}

  defp numeric("4", "1"), do: {[[:down, :press]], "1"}

  defp numeric("4", "2"),
    do:
      {[
         [:down, :right, :press],
         [:right, :down, :press]
       ], "2"}

  defp numeric("4", "3"),
    do:
      {[
         [:down, :right, :right, :press],
         # [:right, :down, :right, :press],
         [:right, :right, :down, :press]
       ], "3"}

  defp numeric("4", "4"), do: {[[:press]], "4"}
  defp numeric("4", "5"), do: {[[:right, :press]], "5"}
  defp numeric("4", "6"), do: {[[:right, :right, :press]], "6"}
  defp numeric("4", "7"), do: {[[:up, :press]], "7"}

  defp numeric("4", "8"),
    do:
      {[
         [:up, :right, :press],
         [:right, :up, :press]
       ], "8"}

  defp numeric("4", "9"),
    do:
      {[
         [:up, :right, :right, :press],
         # [:right, :up, :right, :press],
         [:right, :right, :up, :press]
       ], "9"}

  # From "5"
  defp numeric("5", "0"), do: {[[:down, :down, :press]], "0"}

  defp numeric("5", "A"),
    do:
      {[
         [:down, :down, :right, :press],
         # [:down, :right, :down, :press],
         [:right, :down, :down, :press]
       ], "A"}

  defp numeric("5", "1"),
    do:
      {[
         [:down, :left, :press],
         [:left, :down, :press]
       ], "1"}

  defp numeric("5", "2"), do: {[[:down, :press]], "2"}

  defp numeric("5", "3"),
    do:
      {[
         [:down, :right, :press],
         [:right, :down, :press]
       ], "3"}

  defp numeric("5", "4"), do: {[[:left, :press]], "4"}
  defp numeric("5", "5"), do: {[[:press]], "5"}
  defp numeric("5", "6"), do: {[[:right, :press]], "6"}

  defp numeric("5", "7"),
    do:
      {[
         [:up, :left, :press],
         [:left, :up, :press]
       ], "7"}

  defp numeric("5", "8"), do: {[[:up, :press]], "8"}

  defp numeric("5", "9"),
    do:
      {[
         [:up, :right, :press],
         [:right, :up, :press]
       ], "9"}

  # From "6"
  defp numeric("6", "0"),
    do:
      {[
         [:down, :down, :left, :press],
         # [:down, :left, :down, :press],
         [:left, :down, :down, :press]
       ], "0"}

  defp numeric("6", "A"), do: {[[:down, :down, :press]], "A"}

  defp numeric("6", "1"),
    do:
      {[
         [:down, :left, :left, :press],
         # [:left, :down, :left, :press],
         [:left, :left, :down, :press]
       ], "1"}

  defp numeric("6", "2"),
    do:
      {[
         [:down, :left, :press],
         [:left, :down, :press]
       ], "2"}

  defp numeric("6", "3"), do: {[[:down, :press]], "3"}
  defp numeric("6", "4"), do: {[[:left, :left, :press]], "4"}
  defp numeric("6", "5"), do: {[[:left, :press]], "5"}
  defp numeric("6", "6"), do: {[[:press]], "6"}

  defp numeric("6", "7"),
    do:
      {[
         [:up, :left, :left, :press],
         # [:left, :up, :left, :press],
         [:left, :left, :up, :press]
       ], "7"}

  defp numeric("6", "8"),
    do:
      {[
         [:up, :left, :press],
         [:left, :up, :press]
       ], "8"}

  defp numeric("6", "9"), do: {[[:up, :press]], "9"}

  # From "7"
  defp numeric("7", "0"),
    do:
      {[
         [:right, :down, :down, :down, :press],
         # [:down, :right, :down, :down, :press],
         [:down, :down, :right, :down, :press]
       ], "0"}

  defp numeric("7", "A"),
    do:
      {[
         [:right, :right, :down, :down, :down, :press]
         # [:right, :down, :right, :down, :down, :press],
         # [:right, :down, :down, :right, :down, :press],
         # [:right, :down, :down, :down, :right, :press],
         # [:down, :right, :right, :down, :down, :press],
         # [:down, :right, :down, :right, :down, :press],
         # [:down, :right, :down, :down, :right, :press],
         # [:down, :down, :right, :right, :down, :press],
         # [:down, :down, :right, :down, :right, :press]
       ], "A"}

  defp numeric("7", "1"), do: {[[:down, :down, :press]], "1"}

  defp numeric("7", "2"),
    do:
      {[
         [:down, :down, :right, :press],
         # [:down, :right, :down, :press],
         [:right, :down, :down, :press]
       ], "2"}

  defp numeric("7", "3"),
    do:
      {[
         [:down, :down, :right, :right, :press],
         # [:down, :right, :down, :right, :press],
         # [:down, :right, :right, :down, :press],
         # [:right, :down, :down, :right, :press],
         # [:right, :down, :right, :down, :press],
         [:right, :right, :down, :down, :press]
       ], "3"}

  defp numeric("7", "4"), do: {[[:down, :press]], "4"}

  defp numeric("7", "5"),
    do:
      {[
         [:down, :right, :press],
         [:right, :down, :press]
       ], "5"}

  defp numeric("7", "6"),
    do:
      {[
         [:down, :right, :right, :press],
         # [:right, :down, :right, :press],
         [:right, :right, :down, :press]
       ], "6"}

  defp numeric("7", "7"), do: {[[:press]], "7"}
  defp numeric("7", "8"), do: {[[:right, :press]], "8"}
  defp numeric("7", "9"), do: {[[:right, :right, :press]], "9"}

  # From "8"
  defp numeric("8", "0"), do: {[[:down, :down, :down, :press]], "0"}

  defp numeric("8", "A"),
    do:
      {[
         [:down, :down, :down, :right, :press],
         # [:down, :down, :right, :down, :press],
         # [:down, :right, :down, :down, :press],
         [:right, :down, :down, :down, :press]
       ], "A"}

  defp numeric("8", "1"),
    do:
      {[
         [:down, :down, :left, :press],
         # [:down, :left, :down, :press],
         [:left, :down, :down, :press]
       ], "1"}

  defp numeric("8", "2"), do: {[[:down, :down, :press]], "2"}

  defp numeric("8", "3"),
    do:
      {[
         [:down, :down, :right, :press],
         # [:down, :right, :down, :press],
         [:right, :down, :down, :press]
       ], "3"}

  defp numeric("8", "4"),
    do:
      {[
         [:down, :left, :press],
         [:left, :down, :press]
       ], "4"}

  defp numeric("8", "5"), do: {[[:down, :press]], "5"}

  defp numeric("8", "6"),
    do:
      {[
         [:down, :right, :press],
         [:right, :down, :press]
       ], "6"}

  defp numeric("8", "7"), do: {[[:left, :press]], "7"}
  defp numeric("8", "8"), do: {[[:press]], "8"}
  defp numeric("8", "9"), do: {[[:right, :press]], "9"}

  # From "9"
  defp numeric("9", "0"),
    do:
      {[
         [:down, :down, :down, :left, :press],
         # [:down, :down, :left, :down, :press],
         # [:down, :left, :down, :down, :press],
         [:left, :down, :down, :down, :press]
       ], "0"}

  defp numeric("9", "A"), do: {[[:down, :down, :down, :press]], "A"}

  defp numeric("9", "1"),
    do:
      {[
         [:down, :down, :left, :left, :press],
         # [:down, :left, :down, :left, :press],
         # [:down, :left, :left, :down, :press],
         # [:left, :down, :down, :left, :press],
         # [:left, :down, :left, :down, :press],
         [:left, :left, :down, :down, :press]
       ], "1"}

  defp numeric("9", "2"),
    do:
      {[
         [:down, :down, :left, :press],
         # [:down, :left, :down, :press],
         [:left, :down, :down, :press]
       ], "2"}

  defp numeric("9", "3"), do: {[[:down, :down, :press]], "3"}

  defp numeric("9", "4"),
    do:
      {[
         [:down, :left, :left, :press],
         # [:left, :down, :left, :press],
         [:left, :left, :down, :press]
       ], "4"}

  defp numeric("9", "5"),
    do:
      {[
         [:down, :left, :press],
         [:left, :down, :press]
       ], "5"}

  defp numeric("9", "6"), do: {[[:down, :press]], "6"}
  defp numeric("9", "7"), do: {[[:left, :left, :press]], "7"}
  defp numeric("9", "8"), do: {[[:left, :press]], "8"}
  defp numeric("9", "9"), do: {[[:press]], "9"}

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
