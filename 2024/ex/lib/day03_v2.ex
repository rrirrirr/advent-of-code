defmodule Day03_v2 do
  def part_1(file) do
    File.read!(file)
    |> String.trim()
    |> parse(0)
    |> IO.inspect()
  end

  def part_2(file) do
    File.read!(file)
    |> String.trim()
    |> parse_2(0)
    |> IO.inspect()
  end

  defp waiting(<<>>, sum) do
    sum
  end

  defp waiting(<<"do()", rest::binary>>, sum) do
    parse_2(rest, sum)
  end

  defp waiting(<<_x, rest::binary>>, sum) do
    waiting(rest, sum)
  end

  defp parse_2(<<>>, sum) do
    sum
  end

  defp parse_2(<<"don't()", rest::binary>>, sum) do
    waiting(rest, sum)
  end

  defp parse_2(<<"mul(", rest::binary>>, sum) do
    with {:ok, f1, rest} <- parse_int("", rest),
         {:ok, f2, rest} <- parse_int("", rest) do
      new_sum = f1 * f2 + sum
      parse_2(rest, new_sum)
    else
      _ -> parse_2(rest, sum)
    end
  end

  defp parse_2(<<_x, rest::binary>>, sum) do
    parse_2(rest, sum)
  end

  defp parse(<<>>, sum) do
    sum
  end

  defp parse(<<"mul(", rest::binary>>, sum) do
    with {:ok, f1, rest} <- parse_int("", rest),
         {:ok, f2, rest} <- parse_int("", rest) do
      new_sum = f1 * f2 + sum
      parse(rest, new_sum)
    else
      _ -> parse(rest, sum)
    end
  end

  defp parse(<<_x, rest::binary>>, sum) do
    parse(rest, sum)
  end

  defp parse_int(pre, <<digit::8, rest::binary>>) when digit in ?0..?9 do
    parse_int(pre <> <<digit>>, rest)
  end

  defp parse_int(number, <<",", rest::binary>>) do
    {:ok, String.to_integer(number), rest}
  end

  defp parse_int(number, <<")", rest::binary>>) do
    {:ok, String.to_integer(number), rest}
  end

  defp parse_int(_, rest) do
    {:not_valid, rest}
  end
end
