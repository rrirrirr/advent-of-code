defmodule Day13 do
  def part_1(file) do
    {t, b} = get_input(file)

    b =
      b
      |> Enum.filter(&(&1 != "x"))
      |> Enum.map(&String.to_integer/1)

    t..(t + 100)
    |> Enum.find_value(fn tt ->
      Enum.find_value(b, fn bb ->
        if rem(tt, bb) == 0, do: {bb, tt - t}
      end)
    end)
    |> then(fn {b, t} -> b * t end)
    |> IO.inspect()
  end

  def part_2(file) do
    {_, b} = get_input(file)

    bp =
      b
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.filter(fn {t, _} -> t != "x" end)
      |> Enum.map(fn {t, i} ->
        t = String.to_integer(t)
        {t, rem(i, t)}
      end)
      |> Enum.reverse()
      |> IO.inspect()

    crt = bp |> Enum.product_by(fn {t, _i} -> t end)

    bp
    |> Enum.map(fn {n, o} ->
      nn = div(crt, n)
      y = 1..n |> Enum.find(fn v -> rem(v * nn, n) == o end)
      y * nn
    end)
    |> Enum.sum()
    |> rem(crt)
    |> Kernel.-(length(b) - 1)
    |> IO.inspect()
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> then(fn [p1, p2] ->
      t = p1 |> String.to_integer()

      b =
        p2
        |> String.split(",", trim: true)

      {t, b}
    end)
  end
end
