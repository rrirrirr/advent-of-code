defmodule Day16 do
  def part_1(file) do
    parse_input(file)
    |> parse_packets(0)
  end

  def part_2(file) do
    parse_input(file)
    |> evaluate_packet()
  end

  # Part 1 - Version sum functions
  defp parse_packets("", version_sum), do: version_sum
  defp parse_packets(binary, version_sum) when byte_size(binary) < 11, do: version_sum

  defp parse_packets(binary, version_sum) do
    {version, remaining} = parse_version(binary)
    {type_id, remaining} = parse_type_id(remaining)
    {_value, remaining, sub_versions} = parse_packet_content(remaining, type_id, 0)
    parse_packets(remaining, version_sum + version + sub_versions)
  end

  defp parse_single_packet(binary, version_sum) do
    {version, remaining} = parse_version(binary)
    {type_id, remaining} = parse_type_id(remaining)
    {value, remaining, sub_versions} = parse_packet_content(remaining, type_id, 0)
    {value, remaining, version_sum + version + sub_versions}
  end

  defp parse_packet_content(binary, 4, _version_sum) do
    {value, _remaining} = parse_literal_value(binary)
    groups_count = div(String.length(value), 4)
    total_bits = groups_count * 5
    remaining = String.slice(binary, total_bits..-1//1)
    {value, remaining, 0}
  end

  defp parse_packet_content(binary, _type_id, version_sum) do
    {length_type_id, remaining} = String.split_at(binary, 1)
    parse_operator_packet(remaining, length_type_id, version_sum)
  end

  defp parse_operator_packet(binary, "0", version_sum) do
    {length_bits, remaining} = String.split_at(binary, 15)
    length = binary_to_decimal(length_bits)
    {subpackets, remaining} = String.split_at(remaining, length)
    sub_versions = parse_packets(subpackets, 0)
    {"", remaining, version_sum + sub_versions}
  end

  defp parse_operator_packet(binary, "1", version_sum) do
    {count_bits, remaining} = String.split_at(binary, 11)
    subpacket_count = binary_to_decimal(count_bits)
    {_value, remaining, sub_versions} = parse_n_packets(remaining, subpacket_count, version_sum)
    {"", remaining, sub_versions}
  end

  defp parse_n_packets(binary, 0, version_sum), do: {"", binary, version_sum}

  defp parse_n_packets(binary, count, version_sum) do
    {_value, remaining, new_version_sum} = parse_single_packet(binary, version_sum)
    parse_n_packets(remaining, count - 1, new_version_sum)
  end

  # Part 2 - Evaluation functions
  defp evaluate_packet(binary) do
    {_version, remaining} = parse_version(binary)
    {type_id, remaining} = parse_type_id(remaining)
    {value, _remaining} = evaluate_packet_content(remaining, type_id)
    value
  end

  defp evaluate_packet_content(binary, 4) do
    {value, remaining} = parse_literal_value(binary)
    value = binary_to_decimal(value)
    {value, remaining}
  end

  defp evaluate_packet_content(binary, type_id) do
    {length_type_id, remaining} = String.split_at(binary, 1)
    {values, remaining} = evaluate_operator_packet(remaining, length_type_id)

    value =
      case type_id do
        0 -> Enum.sum(values)
        1 -> Enum.product(values)
        2 -> Enum.min(values)
        3 -> Enum.max(values)
        5 -> if Enum.at(values, 0) > Enum.at(values, 1), do: 1, else: 0
        6 -> if Enum.at(values, 0) < Enum.at(values, 1), do: 1, else: 0
        7 -> if Enum.at(values, 0) == Enum.at(values, 1), do: 1, else: 0
      end

    {value, remaining}
  end

  defp evaluate_operator_packet(binary, "0") do
    {length_bits, remaining} = String.split_at(binary, 15)
    length = binary_to_decimal(length_bits)
    {subpackets, remaining} = String.split_at(remaining, length)
    values = evaluate_subpackets_length(subpackets)
    {values, remaining}
  end

  defp evaluate_operator_packet(binary, "1") do
    {count_bits, remaining} = String.split_at(binary, 11)
    count = binary_to_decimal(count_bits)
    evaluate_n_packets_count(remaining, count, [])
  end

  defp evaluate_subpackets_length(""), do: []
  defp evaluate_subpackets_length(binary) when byte_size(binary) < 11, do: []

  defp evaluate_subpackets_length(binary) do
    {_version, remaining} = parse_version(binary)
    {type_id, remaining} = parse_type_id(remaining)
    {value, remaining} = evaluate_packet_content(remaining, type_id)
    [value | evaluate_subpackets_length(remaining)]
  end

  defp evaluate_n_packets_count(binary, 0, values), do: {Enum.reverse(values), binary}

  defp evaluate_n_packets_count(binary, count, values) do
    {_version, remaining} = parse_version(binary)
    {type_id, remaining} = parse_type_id(remaining)
    {value, remaining} = evaluate_packet_content(remaining, type_id)
    evaluate_n_packets_count(remaining, count - 1, [value | values])
  end

  defp parse_version(binary) do
    {version_bits, remaining} = String.split_at(binary, 3)
    {binary_to_decimal(version_bits), remaining}
  end

  defp parse_type_id(binary) do
    {type_bits, remaining} = String.split_at(binary, 3)
    {binary_to_decimal(type_bits), remaining}
  end

  defp parse_literal_value(binary) do
    {chunk, remaining} = String.split_at(binary, 5)
    {prefix, value_bits} = String.split_at(chunk, 1)

    case prefix do
      "0" ->
        {value_bits, remaining}

      "1" ->
        {rest_value, remaining} = parse_literal_value(remaining)
        {value_bits <> rest_value, remaining}
    end
  end

  defp binary_to_decimal(binary) do
    binary
    |> Integer.parse(2)
    |> elem(0)
  end

  defp hex_to_binary(hex) do
    hex
    |> String.upcase()
    |> Integer.parse(16)
    |> elem(0)
    |> Integer.to_string(2)
    |> String.pad_leading(4, "0")
  end

  defp parse_input(file) do
    File.read!(file)
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&hex_to_binary/1)
    |> Enum.join()
  end
end
