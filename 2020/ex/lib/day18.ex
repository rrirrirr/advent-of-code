defmodule Day18 do
  def part_1(file) do
    input = get_input(file)

    input
    |> Enum.map(fn l ->
      ev(l, 0)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(file) do
    input = get_input(file)

    input
    |> Enum.map(&ip(&1, []))
    |> Enum.map(fn l ->
      ev(l, 0)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp ip(["+" | rest], before) do
    before = ip_r(before, [], 0) |> Enum.reverse()
    rest = ip_f(rest, [], 0) |> Enum.reverse()
    ip(rest, ["+"] ++ before)
  end

  defp ip([any | rest], before) do
    ip(rest, [any] ++ before)
  end

  defp ip([], before), do: Enum.reverse(before)

  defp ip_f([], before, _), do: [")"] ++ before

  defp ip_f(["(" | rest], before, ps) do
    ip_f(rest, ["("] ++ before, ps + 1)
  end

  defp ip_f(["+" | rest], before, 0) do
    Enum.reverse(rest) ++ ["+"] ++ [")"] ++ before
  end

  defp ip_f(["*" | rest], before, 0) do
    Enum.reverse(rest) ++ ["*"] ++ [")"] ++ before
  end

  defp ip_f([s | rest], before, 0) do
    Enum.reverse(rest) ++ [")"] ++ [s] ++ before
  end

  defp ip_f([")" | rest], before, ps) do
    ip_f(rest, [")"] ++ before, ps - 1)
  end

  defp ip_f([s | rest], before, ps) do
    ip_f(rest, [s] ++ before, ps)
  end

  defp ip_r([], before, _), do: ["("] ++ before

  defp ip_r([")" | rest], before, ps) do
    ip_r(rest, [")"] ++ before, ps + 1)
  end

  defp ip_r(["+" | rest], before, 0) do
    Enum.reverse(rest) ++ ["+"] ++ ["("] ++ before
  end

  defp ip_r(["*" | rest], before, 0) do
    Enum.reverse(rest) ++ ["*"] ++ ["("] ++ before
  end

  defp ip_r([s | rest], before, 0) do
    Enum.reverse(rest) ++ ["("] ++ [s] ++ before
  end

  defp ip_r(["(" | rest], before, ps) do
    ip_r(rest, ["("] ++ before, ps - 1)
  end

  defp ip_r([s | rest], before, ps) do
    ip_r(rest, [s] ++ before, ps)
  end

  defp ev([], res), do: res

  defp ev(["*" | rest], res) do
    {num, rest} = next_num(rest)
    ev(rest, res * num)
  end

  defp ev(["+" | rest], res) do
    {num, rest} = next_num(rest)
    ev(rest, res + num)
  end

  defp ev([")" | rest], res), do: {res, rest}

  defp ev(["(" | rest], _res) do
    {num, rest} = next_num(["(" | rest])
    ev(rest, num)
  end

  # is number. Should only get called in beginning or after a "("
  defp ev([num | rest], _res) do
    num = String.to_integer(num)
    ev(rest, num)
  end

  defp next_num(["(" | rest]) do
    ev(rest, 0)
  end

  defp next_num([num | rest]), do: {String.to_integer(num), rest}

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.replace(&1, " ", ""))
    |> Enum.map(&String.split(&1, ~r{[\(\)\+\*]}, include_captures: true, trim: true))
  end
end
