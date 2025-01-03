defmodule Day04 do
  def part_1(file) do
    get_input(file)
    |> Enum.filter(&is_valid?/1)
    |> Enum.filter(&has_valid_fields/1)
    |> Enum.count()
    |> IO.inspect()
  end

  defp is_valid?(passport) do
    fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    fields_in_p = Enum.map(passport, fn {a, _} -> a end)
    fields |> Enum.all?(&Enum.member?(fields_in_p, &1))
  end

  defp has_valid_fields(passport) do
    passport |> Enum.all?(&is_a_valid_field?/1)
  end

  defp is_a_valid_field?({"byr", v}) do
    val = String.to_integer(v)
    if val >= 1920 and val <= 2002, do: true, else: false
  end

  defp is_a_valid_field?({"iyr", v}) do
    val = String.to_integer(v)
    if val >= 2010 and val <= 2020, do: true, else: false
  end

  defp is_a_valid_field?({"eyr", v}) do
    val = String.to_integer(v)
    if val >= 2020 and val <= 2030, do: true, else: false
  end

  defp is_a_valid_field?({"cid", _}), do: true

  defp is_a_valid_field?({"hgt", v}) do
    case Integer.parse(v) do
      {num, "cm"} ->
        num in 150..193

      {num, "in"} ->
        num in 59..76

      _ ->
        false
    end
  end

  defp is_a_valid_field?({"hcl", "#" <> rest}) do
    valid = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
    val = rest |> String.graphemes() |> Enum.drop(1)
    val |> Enum.all?(&Enum.member?(valid, &1)) and String.length(rest) == 6
  end

  defp is_a_valid_field?({"hcl", v}) do
    cond do
      String.length(v) != 7 ->
        false

      not String.starts_with?(v, "#") ->
        false

      true ->
        valid = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
        val = v |> String.graphemes() |> Enum.drop(1)
        val |> Enum.all?(&Enum.member?(valid, &1))
    end
  end

  defp is_a_valid_field?({"ecl", v}) do
    valid = [
      "amb",
      "blu",
      "brn",
      "gry",
      "grn",
      "hzl",
      "oth"
    ]

    Enum.member?(valid, v)
  end

  defp is_a_valid_field?({"pid", v}) do
    cond do
      String.length(v) != 9 ->
        false

      true ->
        valid = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        val = String.graphemes(v)
        val |> Enum.all?(&Enum.member?(valid, &1))
    end
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn pass ->
      pass
      |> String.split(["\n", " "], trim: true)
      |> Enum.map(fn field ->
        String.split(field, ":")
        |> then(fn [a, b] -> {a, b} end)
      end)
    end)
  end
end
