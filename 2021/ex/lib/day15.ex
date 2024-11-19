defmodule Day15 do
  @neighbors [{0, 1}, {-1, 0}, {0, -1}, {1, 0}]

  def part_1(file) do
    grid = get_input(file)
    {risk_map, _} = travel(grid)

    # Get the risk at the end position
    end_pos = {length(grid) - 1, length(List.first(grid)) - 1}
    Map.get(risk_map, end_pos)
  end

  def part_2(file) do
    initial_grid = get_input(file)
    expanded_grid = expand_grid(initial_grid)
    {risk_map, _} = travel(expanded_grid)

    end_pos = {length(expanded_grid) - 1, length(List.first(expanded_grid)) - 1}
    Map.get(risk_map, end_pos)
  end

  defp expand_grid(initial_grid) do
    original_height = length(initial_grid)
    original_width = length(List.first(initial_grid))

    # First expand each row
    horizontal_expanded =
      Enum.map(initial_grid, fn row ->
        Enum.reduce(0..4, [], fn x_repeat, acc ->
          new_segment =
            Enum.map(row, fn value ->
              new_value = value + x_repeat
              if new_value > 9, do: new_value - 9, else: new_value
            end)

          acc ++ new_segment
        end)
      end)

    # Then expand vertically
    Enum.reduce(0..4, [], fn y_repeat, acc ->
      new_segment =
        Enum.map(horizontal_expanded, fn row ->
          Enum.map(row, fn value ->
            new_value = value + y_repeat
            if new_value > 9, do: new_value - 9, else: new_value
          end)
        end)

      acc ++ new_segment
    end)
  end

  defp travel(grid) do
    # Initialize risk map with infinity for all positions except start
    initial_risks =
      for y <- 0..(length(grid) - 1),
          x <- 0..(length(List.first(grid)) - 1),
          into: %{},
          do: {{y, x}, :infinity}

    risk_map = Map.put(initial_risks, {0, 0}, 0)

    # Initialize bucket queue with start position
    initial_queue = [{0, MapSet.new([{0, 0}])}] |> Map.new()

    travel_recursive(grid, risk_map, initial_queue)
  end

  defp travel_recursive(grid, risk_map, queue) when map_size(queue) == 0, do: {risk_map, queue}

  defp travel_recursive(grid, risk_map, queue) do
    # Get the lowest risk bucket
    {current_risk, positions} = Enum.min_by(queue, fn {risk, _} -> risk end)
    current_pos = positions |> MapSet.to_list() |> List.first()

    if is_at_end(grid, current_pos) do
      {risk_map, queue}
    else
      # Remove current position from its bucket
      updated_positions = MapSet.delete(positions, current_pos)

      updated_queue =
        if MapSet.size(updated_positions) == 0 do
          Map.delete(queue, current_risk)
        else
          Map.put(queue, current_risk, updated_positions)
        end

      # Process neighbors
      neighbors = get_valid_neighbors(current_pos, grid)

      {new_risk_map, new_queue} =
        process_neighbors(
          grid,
          neighbors,
          current_pos,
          current_risk,
          risk_map,
          updated_queue
        )

      travel_recursive(grid, new_risk_map, new_queue)
    end
  end

  defp process_neighbors(grid, neighbors, current_pos, current_risk, risk_map, queue) do
    Enum.reduce(neighbors, {risk_map, queue}, fn neighbor, {risks, q} ->
      {y, x} = neighbor
      new_risk = current_risk + Enum.at(Enum.at(grid, y), x)

      if new_risk < Map.get(risks, neighbor, :infinity) do
        # Update risk map
        updated_risks = Map.put(risks, neighbor, new_risk)

        # Update queue
        updated_queue = add_to_bucket_queue(q, new_risk, neighbor)

        {updated_risks, updated_queue}
      else
        {risks, q}
      end
    end)
  end

  defp add_to_bucket_queue(queue, risk, position) do
    current_bucket = Map.get(queue, risk, MapSet.new())
    Map.put(queue, risk, MapSet.put(current_bucket, position))
  end

  defp get_valid_neighbors({y, x}, grid) do
    @neighbors
    |> Enum.map(fn {dy, dx} -> {y + dy, x + dx} end)
    |> Enum.filter(&is_inbounds?(&1, grid))
  end

  defp is_at_end(grid, {y, x}) do
    y == length(grid) - 1 and x == length(List.first(grid)) - 1
  end

  defp is_inbounds?({y, x}, grid) do
    y >= 0 and y < length(grid) and x >= 0 and x < length(List.first(grid))
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.graphemes(row)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
