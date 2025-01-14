defmodule Day16 do
  def part_1(file) do
    {rules, _, tickets} =
      get_input(file)

    tickets
    |> Enum.reject(fn ti ->
      rules
      |> Enum.any?(fn [f, t] ->
        ti in f..t
      end)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(file) do
    {rules, ticket, tickets} = get_input(file)

    l = length(ticket)

    tl =
      tickets
      |> Enum.chunk_every(l)
      |> Enum.filter(fn ti ->
        ti
        |> Enum.all?(fn n ->
          rules
          |> Enum.any?(fn [f, t] ->
            n in f..t
          end)
        end)
      end)

    tlc =
      tl
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.with_index()

    ri =
      rules
      |> Enum.chunk_every(2)
      |> Enum.map(fn [r1, r2] -> {r1, r2} end)

    possibles =
      ri
      |> Enum.map(fn {[f1, t1], [f2, t2]} ->
        tlc
        |> Enum.filter(fn {c, _} ->
          Enum.all?(c, &(&1 in f1..t1 or &1 in f2..t2))
        end)
      end)
      |> Enum.map(fn p ->
        p |> Enum.map(fn {_, idx} -> idx end)
      end)

    1..100
    |> Enum.reduce_while(possibles, fn _, acc ->
      singles = Enum.filter(acc, &(length(&1) == 1)) |> List.flatten()

      if length(singles) == length(acc) do
        {:halt, acc}
      else
        acc =
          acc
          |> Enum.map(fn
            p when length(p) == 1 -> p
            p -> Enum.reject(p, &(&1 in singles))
          end)

        {:cont, acc}
      end
    end)
    |> List.flatten()
    |> Enum.map(&Enum.at(ticket, &1))
    |> Enum.take(6)
    |> Enum.product()
    |> IO.inspect()
  end

  defp get_input(file) do
    [p1, p2, p3] =
      File.read!(file)
      |> String.split(["\n\n"], trim: true)

    p1 =
      p1
      |> String.split(["\n"], trim: true)
      |> Enum.map(&String.split(&1, [": ", " or ", "-"]))
      |> Enum.map(&Enum.drop(&1, 1))
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)

    p2 =
      p2
      |> String.split(["\n", ","], trim: true)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)

    p3 =
      p3
      |> String.split(["\n", ","], trim: true)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)

    {p1, p2, p3}
  end
end
