defmodule Day14 do
  def part_1(file) do
    get_input(file)
    |> Enum.reduce({MapSet.new(), %{}}, fn {mask, ps}, {as, map} ->
      ps
      |> Enum.reduce({as, map}, fn {ad, v}, {as, map} ->
        as = MapSet.put(as, ad)
        to_bin = Integer.to_string(v, 2) |> String.pad_leading(36, "0")

        masked =
          String.graphemes(to_bin)
          |> Enum.zip(String.graphemes(mask))
          |> Enum.map(fn
            {b, "X"} -> b
            {_, v} -> v
          end)
          |> Enum.join()

        map = Map.put(map, ad, masked)
        {as, map}
      end)
    end)
    |> then(fn {as, map} ->
      as
      |> Enum.sum_by(fn a ->
        map |> Map.get(a) |> String.to_integer(2)
      end)
    end)
    |> IO.inspect()
  end

  def part_2(file) do
    get_input(file)
    |> Enum.reduce({MapSet.new(), %{}}, fn {mask, ps}, {as, map} ->
      ps
      |> Enum.reduce({as, map}, fn {ad, v}, {as, map} ->
        to_bin = Integer.to_string(ad, 2) |> String.pad_leading(36, "0")

        masked =
          String.graphemes(to_bin)
          |> Enum.zip(String.graphemes(mask))
          |> Enum.map(fn
            {_, "X"} -> "X"
            {b, "0"} -> b
            {_, "1"} -> "1"
          end)
          |> Enum.join()
          |> then(&pr(&1, ""))

        # |> Enum.map(&String.to_integer/1)

        masked
        |> Enum.reduce({as, map}, fn ad, {ass, mapp} ->
          ass = MapSet.put(ass, String.to_integer(ad, 2))
          mapp = Map.put(mapp, String.to_integer(ad, 2), v)
          {ass, mapp}
        end)
      end)
    end)
    |> then(fn {as, map} ->
      # |> Enum.sum()
      as
      |> Enum.map(&Map.get(map, &1))

      #   |> Enum.map(&String.to_integer(&1, 2))
      #   |> Enum.uniq()
      |> Enum.sum()
    end)
    |> IO.inspect()
  end

  defp pr("", acc), do: [acc]
  defp pr(<<"0", rest::binary>>, acc), do: pr(rest, acc <> "0")
  defp pr(<<"1", rest::binary>>, acc), do: pr(rest, acc <> "1")

  defp pr("X" <> rest, acc) do
    ["0", "1"] |> Enum.flat_map(&pr(rest, acc <> &1))
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("mask =", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(fn [m | p] ->
      pr =
        p
        |> Enum.map(&String.replace(&1, ["mem[", "]", " "], ""))
        |> Enum.map(&String.split(&1, "="))
        |> Enum.map(fn [a, v] -> {String.to_integer(a), String.to_integer(v)} end)

      {String.trim(m), pr}
    end)

    # |> String.split(["\n"], trim: true)
  end
end
