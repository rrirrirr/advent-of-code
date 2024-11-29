defmodule Day01 do
  def part_1(file) do
    numbers = get_input(file)

    numbers
    |> Enum.with_index()
    |> Enum.flat_map(fn {num, idx} ->
      numbers
      |> Enum.with_index()
      |> Enum.reject(fn {_, idx2} ->
        idx == idx2
      end)
      |> Enum.map(fn {num2, _} -> {num, num2} end)
    end)
    |> Enum.find(fn {n1, n2} -> n1 + n2 == 2020 end)
    |> then(fn {n1, n2} -> n1 * n2 end)
  end

  def part_2(file) do
    numbers = get_input(file)

    numbers
    |> Enum.with_index()
    |> Enum.flat_map(fn {num, idx} ->
      numbers
      |> Enum.with_index()
      |> Enum.reject(fn {_, idx2} ->
        idx == idx2
      end)
      |> Enum.flat_map(fn {num2, idx2} ->
        numbers
        |> Enum.with_index()
        |> Enum.reject(fn {_, idx3} ->
          idx == idx2 && idx2 == idx3 && idx == idx3
        end)
        |> Enum.map(fn {num3, _} -> {num, num2, num3} end)
      end)
    end)
    |> Enum.find(fn {n1, n2, n3} -> n1 + n2 + n3 == 2020 end)
    |> then(fn {n1, n2, n3} -> n1 * n2 * n3 end)
  end

  def get_input(file) do
    File.read!(file)
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
  end
end
