defmodule Day24 do
  def part_1(file) do
    {wires, gates} = get_input(file)
    mappings = Enum.into(wires, %{})

    z_codes =
      gates
      |> Enum.map(fn {_, _, _, out} -> out end)
      |> Enum.filter(&String.starts_with?(&1, "z"))
      |> Enum.sort()

    process_until_complete(gates, mappings, z_codes)
    |> then(fn map ->
      z_codes
      |> Enum.map(&Map.get(map, &1))
    end)
    |> Enum.reverse()
    |> Integer.undigits(2)
    |> IO.inspect()
  end

  def part_2(file) do
    {wires, gates} = get_input(file)
    mappings = Enum.into(wires, %{})

    x =
      wires
      |> Enum.filter(fn {code, _} -> String.starts_with?(code, "x") end)

    y =
      wires
      |> Enum.filter(fn {code, _} -> String.starts_with?(code, "y") end)

    z_codes =
      gates
      |> Enum.map(fn {_, _, _, out} -> out end)
      |> Enum.filter(&String.starts_with?(&1, "z"))
      |> Enum.sort()

    z =
      process_until_complete(gates, mappings, z_codes)
      |> then(fn map ->
        z_codes
        |> Enum.map(&{&1, Map.get(map, &1)})
      end)

    x_num = x |> Enum.map(fn {_, b} -> b end) |> Enum.reverse() |> Integer.undigits(2)
    y_num = y |> Enum.map(fn {_, b} -> b end) |> Enum.reverse() |> Integer.undigits(2)
    z_actual = z |> Enum.map(fn {_, b} -> b end) |> Enum.reverse() |> Integer.undigits(2)
    expected_sum = x_num + y_num
    x_bits = x |> Enum.map(fn {_, b} -> b end)
    y_bits = y |> Enum.map(fn {_, b} -> b end)
    z_bits = z |> Enum.map(fn {_, b} -> b end)
    IO.puts("X number: #{x_num}")
    IO.puts("Y number: #{y_num}")
    IO.puts("Expected sum: #{expected_sum}")
    IO.puts("Actual z value: #{z_actual}")

    expected_bits = Integer.digits(expected_sum, 2) |> Enum.reverse()

    len = length(z_bits) - 1

    Enum.zip([x_bits, y_bits, z_bits, expected_bits])
    |> Enum.with_index()
    |> Enum.each(fn {{_x, _y, z, exp}, i} ->
      if z != exp do
        IO.puts("Mismatch at position #{len - i}: got #{z}, expected #{exp}")
      end
    end)

    faulty_ends =
      gates
      |> Enum.filter(fn {_in1, gate, _in2, out} ->
        String.starts_with?(out, "z") and
          gate != "XOR" and out != "z45"
      end)

    faulty_xor =
      gates
      |> Enum.filter(fn {in1, gate, in2, out} ->
        not String.starts_with?(out, "z") and
          gate == "XOR" and
          not ((String.starts_with?(in1, "x") and String.starts_with?(in2, "y")) or
                 (String.starts_with?(in1, "y") and String.starts_with?(in2, "x")))
      end)

    other_faulty_xor =
      find_faulty_xor_gates(gates)

    faulty_and =
      find_faulty_and_gates(gates)

    (faulty_ends ++ faulty_xor ++ other_faulty_xor ++ faulty_and)
    |> Enum.uniq()
    |> Enum.map(fn {_, _, _, out} -> out end)
    |> Enum.sort()
    |> Enum.join(",")
    |> IO.inspect()
  end

  def find_faulty_and_gates(gates) do
    and_gates =
      gates
      |> Enum.filter(fn {_in1, gate, _in2, _out} -> gate == "AND" end)

    and_gates
    |> Enum.filter(fn {_in1, _gate, _in2, out} ->
      not Enum.any?(gates, fn {in1, gate, in2, _next_out} ->
        gate == "OR" and (in1 == out or in2 == out)
      end)
    end)
    |> Enum.reject(fn {in1, _, in2, _} ->
      (in1 == "y00" or
         in1 == "x00") and
        (in2 == "y00" or
           in2 == "x00")
    end)
  end

  def find_faulty_xor_gates(gates) do
    xy_xor_gates =
      gates
      |> Enum.filter(fn {in1, gate, in2, _out} ->
        (String.starts_with?(in1, "x") or String.starts_with?(in1, "y")) and
          (String.starts_with?(in2, "x") or String.starts_with?(in2, "y")) and
          gate == "XOR"
      end)

    xy_xor_gates
    |> Enum.filter(fn {_in1, _gate, _in2, out} ->
      not Enum.any?(gates, fn {in1, gate, in2, _next_out} ->
        gate == "XOR" and (in1 == out or in2 == out)
      end)
    end)
    |> Enum.reject(fn {in1, _, in2, _} ->
      (in1 == "y00" or
         in1 == "x00") and
        (in2 == "y00" or
           in2 == "x00")
    end)
  end

  defp process_until_complete(gates, mappings, z_codes) do
    case z_values_found?(mappings, z_codes) do
      true ->
        mappings

      false ->
        new_mappings = process_gates(gates, mappings)
        process_until_complete(gates, new_mappings, z_codes)
    end
  end

  defp process_gates(gates, mappings) do
    Enum.reduce(gates, mappings, fn {from, gate, to, out}, acc_map ->
      with {:ok, a} <- safe_get(acc_map, from),
           {:ok, b} <- safe_get(acc_map, to) do
        case gate do
          "XOR" -> Map.put(acc_map, out, Bitwise.bxor(a, b))
          "OR" -> Map.put(acc_map, out, Bitwise.bor(a, b))
          "AND" -> Map.put(acc_map, out, Bitwise.band(a, b))
        end
      else
        :error -> acc_map
      end
    end)
  end

  defp safe_get(map, key) do
    case Map.get(map, key) do
      nil -> :error
      value -> {:ok, value}
    end
  end

  defp z_values_found?(mappings, z_codes) do
    Enum.all?(z_codes, &Map.has_key?(mappings, &1))
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n\n", trim: true)
    |> then(fn [p1, p2] ->
      {p1
       |> String.split(["\n", ": "], trim: true)
       |> Enum.chunk_every(2)
       |> Enum.map(fn [a, b] -> {a, String.to_integer(b, 2)} end),
       p2
       |> String.split(["\n", "->", " "], trim: true)
       |> Enum.chunk_every(4)
       |> Enum.map(&List.to_tuple/1)}
    end)
  end
end
