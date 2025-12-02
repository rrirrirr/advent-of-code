defmodule Day01 do
  def part_1(file) do
    get_input(file)
    |> Enum.reduce({50, 0}, fn instruction, {current_position, zeroes} ->
        step(instruction, current_position, zeroes)
    end)
    |>then(&elem(&1, 1))
    |> IO.inspect()
  end

  def part_2(file) do
    get_input(file)
    |> Enum.reduce({50, 0}, fn instruction, {current_position, zeroes} ->
       step_2(instruction, current_position, zeroes)
    end)
    |> then(&elem(&1,1))
    |> IO.inspect()
  end

  defp step(instruction, current_position, zeroes)
  defp step({:LEFT, distance}, current_position, zeroes) do
    new_position = Integer.mod(current_position - distance, 100)
   {new_position, add_to_zeroes(new_position, zeroes)}
  end 
  defp step({:RIGHT, distance}, current_position, zeroes) do
    new_position = Integer.mod(current_position + distance, 100)
   {new_position, add_to_zeroes(new_position, zeroes)}
  end 

  defp add_to_zeroes(0, zeroes), do: zeroes + 1 
  defp add_to_zeroes(_, zeroes), do: zeroes 

  defp step_2(instruction, current_position, zeroes)
  defp step_2({:LEFT, distance}, current_position, zeroes) do
    new_position = Integer.mod(current_position - distance, 100)
   {new_position, add_to_zeroes_2(current_position, -distance, zeroes)}
  end 
  defp step_2({:RIGHT, distance}, current_position, zeroes) do
    new_position = Integer.mod(current_position + distance, 100)
   {new_position, add_to_zeroes_2(current_position, distance, zeroes)}
  end 

  defp add_to_zeroes_2(position, distance, zeroes) do
   end_position = position + distance  
   crossings =
      if distance > 0 do
        Integer.floor_div(end_position, 100)
      else
        Integer.floor_div(end_position, -100) - Integer.floor_div(-position, 100)
      end

    zeroes + crossings
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split(["\n"], trim: true)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.split_at(&1, 1))
    |> Enum.map(fn input ->
      case input do
        {"L", distance} -> {:LEFT, String.to_integer(distance)}
        {"R", distance} -> {:RIGHT, String.to_integer(distance)}
      end
    end)
  end
end
