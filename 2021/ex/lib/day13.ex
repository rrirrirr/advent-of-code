defmodule Day13 do
  def part_1(file) do
    {[first_fold | _], coords} = get_input(file)

    fold_paper(coords, first_fold)
    |> length()
  end

  def part_2(file) do
    {folds, coords} = get_input(file)

    size =
      coords
      |> Enum.reduce({0, 0}, fn {x, y}, {mx, my} ->
        {max(x, mx), max(y, my)}
      end)

    {final_coords, final_size} =
      Enum.reduce(folds, {coords, size}, fn fold, {current_coords, current_size} ->
        {fold_paper(current_coords, fold), half_paper(current_size, fold)}
      end)

    print_coords(final_coords, final_size)
  end

  defp print_coords(coords, {mx, my}) do
    for y <- 0..(my - 1) do
      for x <- 0..(mx - 1) do
        if {x, y} in coords, do: "O", else: " "
      end
      |> Enum.join()
    end
  end

  defp half_paper({mx, my}, {label, _}) when label == "y", do: {mx, div(my, 2)}
  defp half_paper({mx, my}, {label, _}) when label == "x", do: {div(mx, 2), my}

  defp fold_paper(coords, {label, where}) when label == "y" do
    coords
    |> Enum.map(fn {x, y} ->
      if y >= where do
        {x, where - (y - where)}
      else
        {x, y}
      end
    end)
    |> Enum.uniq()
  end

  defp fold_paper(coords, {label, where}) when label == "x" do
    coords
    |> Enum.map(fn {x, y} ->
      if x >= where do
        {where - (x - where), y}
      else
        {x, y}
      end
    end)
    |> Enum.uniq()
  end

  defp get_input(file) do
    [coords, folds] = File.read!(file) |> String.split("\n\n")

    parsed_coords =
      coords
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> then(fn [x, y] -> {x, y} end)
      end)

    parsed_folds =
      folds
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.slice(&1, 11..-1//1))
      |> Enum.map(&String.split(&1, "="))
      |> Enum.map(fn [label, pos] -> {label, String.to_integer(pos)} end)

    {parsed_folds, parsed_coords}
  end
end
