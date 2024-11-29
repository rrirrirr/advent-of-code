defmodule Day02 do
  def part_1(file) do
    get_input(file)
    |> Enum.count(fn {{minn, maxx}, char, password} ->
      count =
        password
        |> String.graphemes()
        |> Enum.count(&(&1 == char))

      count >= minn && count <= maxx
    end)
  end

  def part_2(file) do
    get_input(file)
    |> Enum.count(fn {{p1, p2}, char, password} ->
      String.at(password, p1 - 1) == char != (String.at(password, p2 - 1) == char)
    end)
  end

  def get_input(file) do
    File.read!(file)
    |> String.split(["\n", " ", ": ", "-"])
    |> Enum.reject(&(&1 == ""))
    |> Enum.chunk_every(4)
    |> Enum.map(fn [s, e, char, password] ->
      {{String.to_integer(s), String.to_integer(e)}, char, password}
    end)
  end
end
