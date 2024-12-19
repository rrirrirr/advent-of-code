defmodule Day17 do
  require Bitwise

  def part_1(file) do
    {[a, b, c], program} = get_input(file)

    1..100_000
    |> Enum.reduce_while({{a, b, c, 0}, ""}, fn _, {registers, acc_output} ->
      {_, _, _, ptr} = registers

      if ptr >= length(program) do
        {:halt, acc_output}
      else
        opcode = Enum.at(program, ptr)
        oper = Enum.at(program, ptr + 1)
        {new_registers, new_output} = process(registers, opcode, oper)

        output_str =
          if new_output != "",
            do: acc_output <> if(acc_output == "", do: new_output, else: "," <> new_output),
            else: acc_output

        {:cont, {new_registers, output_str}}
      end
    end)
    |> IO.inspect()
  end

  def part_2(file) do
    {[_, b, c], program} = get_input(file)
    looking_for = Enum.join(program, "")
    program_length = String.length(looking_for)

    lower_bound =
      1..1000
      |> Enum.find(fn n ->
        a = 10 ** n
        v = do_program({a, b, c, 0}, program)

        program_length - 2 == String.length(v)
      end)

    middle_bound =
      1..1000
      |> Enum.find(fn n ->
        a = 10 ** n
        v = do_program({a, b, c, 0}, program)

        program_length == String.length(v)
      end)

    upper_bound =
      lower_bound..(lower_bound * 10)
      |> Enum.find(fn n ->
        a = 10 ** n
        v = do_program({a, b, c, 0}, program)

        program_length + 2 == String.length(v)
      end)

    {lb, mb, ub} = {10 ** lower_bound, 10 ** middle_bound, 10 ** upper_bound}

    lb =
      1..1000
      |> Enum.reduce_while({lb, mb}, fn _, {l, u} ->
        mid = l + div(u - l, 2)
        v = do_program({mid, b, c, 0}, program)

        delta_l = String.length(v) - program_length

        cond do
          u - l == 1 ->
            {:halt, {l, u}}

          delta_l == 0 ->
            {:cont, {l, mid}}

          delta_l < 0 ->
            {:cont, {mid, u}}
        end
      end)
      |> elem(1)

    ub =
      1..1000
      |> Enum.reduce_while({mb, ub}, fn _, {l, u} ->
        mid = l + div(u - l, 2)
        v = do_program({mid, b, c, 0}, program)

        delta_l = String.length(v) - program_length

        cond do
          u - l == 1 ->
            {:halt, {l, u}}

          delta_l == 0 ->
            {:cont, {mid, u}}

          delta_l > 0 ->
            {:cont, {l, mid}}
        end
      end)
      |> elem(0)

    granularity = 1000

    {lb, ub} =
      find_sequence(program_length, looking_for, {lb, ub}, b, c, program, granularity, 1, [])

    lb..ub
    |> Enum.find(fn n ->
      v = do_program({n, b, c, 0}, program)
      v == looking_for
    end)
    |> IO.inspect()
  end

  defp find_sequence(
         _program_length,
         _looking_for,
         {lb, ub},
         _b,
         _c,
         _program,
         _granularity,
         12,
         _history
       ) do
    {lb, ub}
  end

  defp find_sequence(
         program_length,
         looking_for,
         {lb, ub},
         b,
         c,
         program,
         granularity,
         pos,
         history
       ) do
    # IO.inspect("#{lb} #{ub}", label: pos)
    digit_to_look_for = String.at(looking_for, -pos)
    # IO.inspect(do_program({lb, b, c, 0}, program), label: "lower v")
    # IO.inspect(do_program({ub, b, c, 0}, program), label: "upper v")

    {nl, nu} = find_range(digit_to_look_for, -pos, {lb, ub}, granularity, {b, c}, program)

    cond do
      lb == ub ->
        {lb, ub}

      nl >= nu ->
        case history do
          [] ->
            {lb, ub}

          [{_prev_digit, prev_lb, prev_ub} | rest_history] ->
            prev_delta = prev_ub - prev_lb

            find_sequence(
              program_length,
              looking_for,
              {prev_ub + 1, prev_ub + prev_delta * 100},
              b,
              c,
              program,
              granularity,
              pos - 1,
              rest_history
            )
        end

      pos == program_length ->
        {nl, nu}

      true ->
        find_sequence(
          program_length,
          looking_for,
          {nl, nu},
          b,
          c,
          program,
          granularity,
          pos + 1,
          [{digit_to_look_for, nl, nu} | history]
        )
    end
  end

  defp find_range(digit_to_look_for, pos, {lb, ub}, granularity, {b, c}, program) do
    step_size = max(1, div(ub - lb, granularity))
    expected_tail = program |> Enum.take(-abs(pos + 1)) |> Enum.join()

    {lwl, lwu} =
      1..granularity
      |> Enum.reduce_while({lb, ub}, fn step, {l, u} ->
        current = l + step * step_size
        v = do_program({current, b, c, 0}, program)
        cur_digit = String.at(v, pos)
        cur_tail = String.slice(v, (String.length(v) + pos + 1)..-1//1)

        if cur_digit == digit_to_look_for and cur_tail == expected_tail do
          {:halt, {l, current}}
        else
          {:cont, {current, u}}
        end
      end)

    new_lower =
      1..granularity
      |> Enum.reduce_while({lwl, lwu}, fn _, {l, u} ->
        mid = l + div(u - l, 2)
        v = do_program({mid, b, c, 0}, program)
        cur_digit = String.at(v, pos)
        cur_tail = String.slice(v, (String.length(v) + pos + 1)..-1//1)

        if cur_digit == digit_to_look_for and cur_tail == expected_tail do
          {:cont, {l, mid}}
        else
          {:cont, {mid, u}}
        end
      end)

    {_, uwl} = new_lower

    new_upper =
      1..granularity
      |> Enum.reduce_while({uwl, ub}, fn _, {l, u} ->
        mid = l + div(u - l, 2)
        v = do_program({mid, b, c, 0}, program)
        cur_digit = String.at(v, pos)
        cur_tail = String.slice(v, (String.length(v) + pos + 1)..-1//1)

        if cur_digit == digit_to_look_for and cur_tail == expected_tail do
          {:cont, {mid, u}}
        else
          {:cont, {l, mid}}
        end
      end)

    {elem(new_lower, 1), elem(new_upper, 0)}
  end

  defp do_program(initial_reg, program) do
    Enum.reduce_while(1..100_000, {initial_reg, ""}, fn _, {registers, acc_output} ->
      {_, _, _, ptr} = registers

      if ptr >= length(program) do
        {:halt, acc_output}
      else
        opcode = Enum.at(program, ptr)
        oper = Enum.at(program, ptr + 1)
        {new_registers, new_output} = process(registers, opcode, oper)

        output_str =
          acc_output <> new_output

        {:cont, {new_registers, output_str}}
      end
    end)
  end

  defp process({a, b, c, ptr}, 0, oper),
    do: {{div(a, 2 ** combo({a, b, c}, oper)), b, c, ptr + 2}, ""}

  defp process({a, b, c, ptr}, 1, oper), do: {{a, Bitwise.bxor(b, oper), c, ptr + 2}, ""}
  defp process({a, b, c, ptr}, 2, oper), do: {{a, rem(combo({a, b, c}, oper), 8), c, ptr + 2}, ""}
  defp process({0, b, c, ptr}, 3, _), do: {{0, b, c, ptr + 2}, ""}
  defp process({a, b, c, _}, 3, oper), do: {{a, b, c, oper}, ""}
  defp process({a, b, c, ptr}, 4, _), do: {{a, Bitwise.bxor(b, c), c, ptr + 2}, ""}

  defp process({a, b, c, ptr}, 5, oper),
    do: {{a, b, c, ptr + 2}, Integer.to_string(rem(combo({a, b, c}, oper), 8))}

  defp process({a, b, c, ptr}, 6, oper),
    do: {{a, div(a, 2 ** combo({a, b, c}, oper)), c, ptr + 2}, ""}

  defp process({a, b, c, ptr}, 7, oper),
    do: {{a, b, div(a, 2 ** combo({a, b, c}, oper)), ptr + 2}, ""}

  defp combo({_a, _b, _c}, op) when op in 0..3, do: op
  defp combo({a, _b, _c}, 4), do: a
  defp combo({_a, b, _c}, 5), do: b
  defp combo({_a, _b, c}, 6), do: c

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n\n", trim: true)
    |> then(fn [p1, p2] ->
      registers =
        p1
        |> String.split(["\n", " "])
        |> Enum.drop(2)
        |> Enum.take_every(3)
        |> Enum.map(&String.to_integer/1)

      program =
        p2
        |> String.split(["\n", "Program: ", ","], trim: true)
        |> Enum.map(&String.to_integer/1)

      {registers, program}
    end)
  end
end
