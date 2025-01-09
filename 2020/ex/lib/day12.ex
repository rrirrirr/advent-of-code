defmodule Day12 do
  def part_1(file) do
    get_input(file)
    |> Enum.reduce({"E", 0, 0}, fn
      {"N", s}, {d, x, y} ->
        {d, x, y + s}

      {"S", s}, {d, x, y} ->
        {d, x, y - s}

      {"E", s}, {d, x, y} ->
        {d, x + s, y}

      {"W", s}, {d, x, y} ->
        {d, x - s, y}

      {"L", s}, {d, x, y} ->
        d = nd("L", d, s)
        {d, x, y}

      {"R", s}, {d, x, y} ->
        d = nd("R", d, s)
        {d, x, y}

      {"F", s}, {d, x, y} ->
        {x, y} = m(d, {x, y}, s)
        {d, x, y}
    end)
    |> then(fn {_, x, y} -> abs(x) + abs(y) end)
    |> IO.inspect()
  end

  def part_2(file) do
    get_input(file)
    |> Enum.reduce({{10, 1}, {0, 0}}, fn
      {"N", s}, {{wx, wy}, {x, y}} ->
        {{wx, wy + s}, {x, y}}

      {"S", s}, {{wx, wy}, {x, y}} ->
        {{wx, wy - s}, {x, y}}

      {"E", s}, {{wx, wy}, {x, y}} ->
        {{wx + s, wy}, {x, y}}

      {"W", s}, {{wx, wy}, {x, y}} ->
        {{wx - s, wy}, {x, y}}

      {"L", s}, {{wx, wy}, {x, y}} ->
        w = rotate("L", s, {wx, wy})
        {w, {x, y}}

      {"R", s}, {{wx, wy}, {x, y}} ->
        w = rotate("R", s, {wx, wy})
        {w, {x, y}}

      {"F", s}, {{wx, wy}, {x, y}} ->
        {{wx, wy}, {x + wx * s, y + wy * s}}
    end)
    |> then(fn {_, {x, y}} -> abs(x) + abs(y) end)
    |> IO.inspect()
  end

  defp rotate("L", a, {wx, wy}) do
    case a do
      90 -> {-wy, wx}
      180 -> {-wx, -wy}
      270 -> {wy, -wx}
    end
  end

  defp rotate("R", a, {wx, wy}) do
    case a do
      90 -> {wy, -wx}
      180 -> {-wx, -wy}
      270 -> {-wy, wx}
    end
  end

  defp nd("L", d, a) do
    case {d, a} do
      {"E", 90} -> "N"
      {"E", 180} -> "W"
      {"E", 270} -> "S"
      {"W", 90} -> "S"
      {"W", 180} -> "E"
      {"W", 270} -> "N"
      {"N", 90} -> "W"
      {"N", 180} -> "S"
      {"N", 270} -> "E"
      {"S", 90} -> "E"
      {"S", 180} -> "N"
      {"S", 270} -> "W"
    end
  end

  defp nd("R", d, a) do
    case {d, a} do
      {"E", 90} -> "S"
      {"E", 180} -> "W"
      {"E", 270} -> "N"
      {"W", 90} -> "N"
      {"W", 180} -> "E"
      {"W", 270} -> "S"
      {"N", 90} -> "E"
      {"N", 180} -> "S"
      {"N", 270} -> "W"
      {"S", 90} -> "W"
      {"S", 180} -> "N"
      {"S", 270} -> "E"
    end
  end

  defp m("E", {x, y}, s), do: {x + s, y}
  defp m("W", {x, y}, s), do: {x - s, y}
  defp m("N", {x, y}, s), do: {x, y + s}
  defp m("S", {x, y}, s), do: {x, y - s}

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn <<d::8, num::binary>> -> {<<d>>, String.to_integer(num)} end)
  end
end
