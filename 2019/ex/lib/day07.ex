defmodule Day07 do
  def part_1(file) do
    input = get_input(file)
    phases = permute([0, 1, 2, 3, 4])

    phases
    |> Enum.map(&run_amp(&1, input))
    |> Enum.max()
    |> IO.inspect()
  end

  def part_2(file) do
    input = get_input(file)
    phases = permute([5, 6, 7, 8, 9])

    phases
    |> Enum.map(fn phase ->
      amps =
        phase
        |> Enum.with_index()
        |> Enum.map(fn {p, i} -> {i, {input, 0, [p]}} end)
        |> Map.new()

      run_amp_loop(amps, 0, 0, 0)
    end)
    |> Enum.max()
    |> IO.inspect()
  end

  defp permute([]), do: [[]]

  defp permute(list) do
    for elem <- list, rest <- permute(list -- [elem]) do
      [elem | rest]
    end
  end

  defp run_amp(phase, program) do
    Enum.reduce(phase, 0, fn p, signal ->
      {_, _, _, output} = process(program, 0, [p, signal], [])
      output
    end)
  end

  defp run_amp_loop(amps, current_amp, input, last_output) do
    all_halted = Enum.all?(amps, fn {_, {_, pos, _}} -> pos == -1 end)

    if all_halted do
      last_output
    else
      {program, pos, inputs} = Map.get(amps, current_amp)

      if pos == -1 do
        next_amp = rem(current_amp + 1, 5)
        run_amp_loop(amps, next_amp, input, last_output)
      else
        inputs = inputs ++ [input]

        {signal, program, new_pos, output} = process(program, pos, inputs, [])

        current_output = if output != nil, do: output, else: input
        new_last_output = if current_amp == 4, do: current_output, else: last_output

        case signal do
          :halt ->
            updated_amps = Map.put(amps, current_amp, {program, -1, []})

            if current_amp == 4 do
              new_last_output
            else
              next_amp = rem(current_amp + 1, 5)
              run_amp_loop(updated_amps, next_amp, current_output, new_last_output)
            end

          :cont ->
            updated_amps = Map.put(amps, current_amp, {program, new_pos, []})

            next_amp = rem(current_amp + 1, 5)
            run_amp_loop(updated_amps, next_amp, current_output, new_last_output)
        end
      end
    end
  end

  defp process(p, pos, inputs, outputs) do
    opcode_value = Enum.at(p, pos)

    if is_nil(opcode_value) do
      {:halt, p, pos, List.first(outputs)}
    else
      {_m3, m2, m1, opcode} = process_code(opcode_value)

      case opcode do
        1 ->
          p1 = get_param(p, m1, pos + 1)
          p2 = get_param(p, m2, pos + 2)
          d = Enum.at(p, pos + 3)
          p = List.replace_at(p, d, p1 + p2)
          process(p, pos + 4, inputs, outputs)

        2 ->
          p1 = get_param(p, m1, pos + 1)
          p2 = get_param(p, m2, pos + 2)
          d = Enum.at(p, pos + 3)
          p = List.replace_at(p, d, p1 * p2)
          process(p, pos + 4, inputs, outputs)

        3 ->
          case inputs do
            [] ->
              {:cont, p, pos, nil}

            [input | remaining_inputs] ->
              d = Enum.at(p, pos + 1)
              p = List.replace_at(p, d, input)
              process(p, pos + 2, remaining_inputs, outputs)
          end

        4 ->
          output = get_param(p, m1, pos + 1)
          {:cont, p, pos + 2, output}

        5 ->
          p1 = get_param(p, m1, pos + 1)

          if p1 > 0 do
            p2 = get_param(p, m2, pos + 2)
            process(p, p2, inputs, outputs)
          else
            process(p, pos + 3, inputs, outputs)
          end

        6 ->
          p1 = get_param(p, m1, pos + 1)

          if p1 == 0 do
            p2 = get_param(p, m2, pos + 2)
            process(p, p2, inputs, outputs)
          else
            process(p, pos + 3, inputs, outputs)
          end

        7 ->
          p1 = get_param(p, m1, pos + 1)
          p2 = get_param(p, m2, pos + 2)
          d = Enum.at(p, pos + 3)

          if p1 < p2 do
            p = List.replace_at(p, d, 1)
            process(p, pos + 4, inputs, outputs)
          else
            p = List.replace_at(p, d, 0)
            process(p, pos + 4, inputs, outputs)
          end

        8 ->
          p1 = get_param(p, m1, pos + 1)
          p2 = get_param(p, m2, pos + 2)
          d = Enum.at(p, pos + 3)

          if p1 == p2 do
            p = List.replace_at(p, d, 1)
            process(p, pos + 4, inputs, outputs)
          else
            p = List.replace_at(p, d, 0)
            process(p, pos + 4, inputs, outputs)
          end

        99 ->
          {:halt, p, pos, List.first(outputs)}

        _ ->
          {:halt, p, pos, List.first(outputs)}
      end
    end
  end

  defp get_param(p, :position, pos) do
    index = Enum.at(p, pos)

    if is_nil(index) || index < 0 || index >= length(p) do
      0
    else
      Enum.at(p, index)
    end
  end

  defp get_param(p, :immediate, pos) do
    val = Enum.at(p, pos)
    if is_nil(val), do: 0, else: val
  end

  defp process_code(code) do
    code =
      case code do
        nil -> 0
        val when is_integer(val) -> val
        _ -> 0
      end

    padded = Integer.digits(code) |> then(fn d -> List.duplicate(0, 5 - length(d)) ++ d end)
    opcode = padded |> Enum.take(-2) |> Integer.undigits()

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
