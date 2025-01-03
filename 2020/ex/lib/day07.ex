defmodule Day07 do
  def part_1(file) do
    {bags, map} =
      get_input(file)

    bags
    |> Enum.filter(&has_shiny(map, &1))
    |> Enum.count()
    |> IO.inspect()
  end

  def part_2(file) do
    {_bags, map} =
      get_input(file)

    levels(map, "shiny gold")
    |> IO.inspect()
  end

  defp has_shiny(map, bag) do
    Map.get(map, bag)
    |> Enum.map(fn s ->
      cond do
        s == "no other" ->
          false

        true ->
          {_num, bagg} = String.split_at(s, 1)
          <<_::utf8, bagg::binary>> = bagg

          if bagg == "shiny gold" do
            true
          else
            has_shiny(map, bagg)
          end
      end
    end)
    |> Enum.any?(&(&1 == true))
  end

  defp levels(map, bag) do
    Map.get(map, bag)
    |> Enum.map(fn
      "no other" ->
        0

      content ->
        [num, rest] = String.split(content, " ", parts: 2)
        num = String.to_integer(num)
        num * (1 + levels(map, rest))
    end)
    |> Enum.sum()
  end

  defp get_input(file) do
    map =
      File.read!(file)
      |> String.split(["\n"], trim: true)
      |> Enum.map(
        &String.split(&1, [" bags contain ", ", ", " bags.", " bag", " bags", "."], trim: true)
      )
      |> Enum.map(fn [from | to] -> {from, to} end)
      |> Map.new()

    {Map.keys(map), map}
  end
end
