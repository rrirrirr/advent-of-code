defmodule Day04 do
  def part_1(file) do
    grid = get_input(file)

    grid
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      Enum.with_index(row)
      |> Enum.map(fn {l, x} -> {l, {x, y}} end)
    end)
    |> Enum.filter(fn {l, _} -> l == "X" end)
    |> Enum.flat_map(fn {_l, coords} -> get_words(grid, coords) end)
    |> Enum.count(&(&1 == "XMAS"))
    |> IO.inspect()
  end

  def part_2(file) do
    grid = get_input(file)

    grid
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      Enum.with_index(row)
      |> Enum.map(fn {l, x} -> {l, {x, y}} end)
    end)
    |> Enum.filter(fn {l, _} -> l == "A" end)
    |> Enum.filter(fn {_, coords} -> is_mas_cross(grid, coords) end)
    |> Enum.count()
    |> IO.inspect()
  end

  defp get_words(grid, coords) do
    [
      get_forward_word(grid, coords),
      get_backwards_word(grid, coords),
      get_vertical_down_word(grid, coords),
      get_vertical_up_word(grid, coords),
      get_diagonal_ul(grid, coords),
      get_diagonal_ur(grid, coords),
      get_diagonal_dl(grid, coords),
      get_diagonal_dr(grid, coords)
    ]
  end

  defp is_mas_cross(grid, {x, y}) do
    width = hd(grid) |> length()
    height = length(grid)

    cond do
      x > 0 and x < width - 1 and y > 0 and y < height - 1 ->
        first_is_correct =
          ["MS", "SM"]
          |> Enum.member?(get_letter(grid, {x - 1, y - 1}) <> get_letter(grid, {x + 1, y + 1}))

        second_is_correct =
          ["MS", "SM"]
          |> Enum.member?(get_letter(grid, {x + 1, y - 1}) <> get_letter(grid, {x - 1, y + 1}))

        first_is_correct and second_is_correct

      true ->
        false
    end
  end

  defp get_backwards_word(grid, {x, y}) do
    for xs <- x..(x - 3)//-1, xs >= 0, into: "", do: get_letter(grid, {xs, y})
  end

  defp get_forward_word(grid, {x, y}) do
    width = hd(grid) |> length()
    for xs <- x..(x + 3), xs < width, into: "", do: get_letter(grid, {xs, y})
  end

  defp get_diagonal_ul(grid, {x, y}) do
    for i <- 0..3,
        new_x = x - i,
        new_y = y - i,
        new_x >= 0,
        new_y >= 0,
        into: "",
        do: get_letter(grid, {new_x, new_y})
  end

  defp get_diagonal_ur(grid, {x, y}) do
    width = hd(grid) |> length()

    for i <- 0..3,
        new_x = x + i,
        new_y = y - i,
        new_x < width,
        new_y >= 0,
        into: "",
        do: get_letter(grid, {new_x, new_y})
  end

  defp get_diagonal_dr(grid, {x, y}) do
    width = hd(grid) |> length()
    height = length(grid)

    for i <- 0..3,
        new_x = x + i,
        new_y = y + i,
        new_x < width,
        new_y < height,
        into: "",
        do: get_letter(grid, {new_x, new_y})
  end

  defp get_diagonal_dl(grid, {x, y}) do
    height = length(grid)

    for i <- 0..3,
        new_x = x - i,
        new_y = y + i,
        new_x >= 0,
        new_y < height,
        into: "",
        do: get_letter(grid, {new_x, new_y})
  end

  defp get_vertical_down_word(grid, {x, y}) do
    height = length(grid)
    for ys <- y..(y + 3), ys < height, into: "", do: get_letter(grid, {x, ys})
  end

  defp get_vertical_up_word(grid, {x, y}) do
    for ys <- y..(y - 3)//-1, ys >= 0, into: "", do: get_letter(grid, {x, ys})
  end

  defp get_letter(grid, {x, y}), do: Enum.at(grid, y) |> Enum.at(x)

  defp get_input(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
