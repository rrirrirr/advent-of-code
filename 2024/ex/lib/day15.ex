defmodule Day15 do
  def part_1(file) do
    {grid, moves} = get_input(file)

    moves
    |> Enum.reduce(grid, fn move, grid ->
      # IO.puts("\nAfter moving #{move}:")

      move_robot(grid, move)
      |> print_grid()
    end)
    |> then(&calc_score/1)
    |> IO.inspect()
  end

  def part_2(file) do
    {grid, moves} = get_input(file)

    doubled_grid =
      grid
      |> Enum.map(fn row ->
        Enum.flat_map(row, fn
          "#" -> ["#", "#"]
          "." -> [".", "."]
          "O" -> ["[", "]"]
          "@" -> ["@", "."]
        end)
      end)

    moves
    |> Enum.reduce(doubled_grid, fn move, grid ->
      # IO.puts("\nAfter moving #{move}:")

      dmove_robot(grid, move)
      |> print_grid()
    end)
    |> then(&calc_score_2/1)
    |> IO.inspect()
  end

  defp print_grid(grid) do
    IO.write("\e[2J\e[H")

    grid
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> IO.puts()

    # Process.sleep(10)

    grid
  end

  defp calc_score(grid) do
    width = length(hd(grid))
    height = length(grid)

    grid
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.filter(fn {s, _} -> s == "O" end)
    |> Enum.map(fn {_, idx} -> 100 * div(idx, height) + rem(idx, width) end)
    |> Enum.sum()
  end

  defp calc_score_2(grid) do
    grid
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      Enum.with_index(row) |> Enum.map(fn {c, x} -> {c, x, y} end)
    end)
    |> Enum.filter(fn {c, _, _} -> c == "[" end)
    |> Enum.map(fn {_, x, y} -> y * 100 + x end)
    |> Enum.sum()
  end

  defp dmove_robot(grid, :left) do
    {before_robot, robot_row, after_robot} = find_robot_row([], grid)
    updated_row = eliminate_empty_space_before_robot(robot_row, 0, [], [])
    before_robot ++ [updated_row] ++ after_robot
  end

  defp dmove_robot(grid, :right) do
    {before_robot, robot_row, after_robot} = find_robot_row([], grid)

    updated_row =
      eliminate_empty_space_before_robot(Enum.reverse(robot_row), 0, [], [])
      |> Enum.reverse()

    before_robot ++ [updated_row] ++ after_robot
  end

  defp dmove_robot(grid, :up) do
    transposed_grid = transpose_grid(grid)
    {before_robot, robot_row, after_robot} = find_robot_row([], transposed_grid)

    find_possible_moves(
      before_robot |> Enum.map(&Enum.reverse/1),
      robot_row |> Enum.reverse(),
      after_robot |> Enum.map(&Enum.reverse/1)
    )
    |> Enum.map(&Enum.reverse/1)
    |> transpose_grid()
  end

  defp dmove_robot(grid, :down) do
    transposed_grid = transpose_grid(grid)
    {before_robot, robot_row, after_robot} = find_robot_row([], transposed_grid)

    find_possible_moves(before_robot, robot_row, after_robot) |> transpose_grid()
  end

  defp find_possible_moves(to_left, current_col, to_right) do
    robot_position = Enum.find_index(current_col, &(&1 == "@"))

    above_slice = to_left |> Enum.map(&Enum.drop(&1, robot_position - 1))
    below_slice = to_right |> Enum.map(&Enum.drop(&1, robot_position - 1))
    current_slice = current_col |> Enum.drop(robot_position)

    moves =
      check_move_validity(above_slice, current_slice, below_slice, {0, 0}, :no, MapSet.new())
      |> List.flatten()
      |> Enum.reject(fn
        {:duplicate, _} -> true
        _ -> false
      end)
      |> Enum.uniq()
      |> Enum.sort_by(fn {_, {_x, y}} -> -y end)

    case Enum.all?(moves, &match?({:valid_move, _}, &1)) do
      true ->
        start_col = length(to_left)
        start_row = robot_position

        moves
        |> Enum.reduce(to_left ++ [current_col] ++ to_right, fn {_, {x, y}}, grid ->
          col_to_change = start_col + x
          row_to_change = start_row + y

          grid
          |> Enum.with_index()
          |> Enum.map(fn {col, col_idx} ->
            if col_idx == col_to_change do
              cur_val = Enum.at(col, row_to_change)
              next_val = Enum.at(col, row_to_change + 1)

              Enum.take(col, row_to_change) ++
                [next_val, cur_val] ++ Enum.drop(col, row_to_change + 2)
            else
              col
            end
          end)
        end)

      false ->
        to_left ++ [current_col] ++ to_right
    end
  end

  defp check_move_validity(
         left_cols,
         [cell | remaining_cells],
         right_cols,
         {hor_pos, ver_pos},
         hor_move,
         processed
       ) do
    if MapSet.member?(processed, {hor_pos, ver_pos}) do
      {:duplicate, {0, 0}}
    else
      left_cols =
        case hor_move do
          :yes -> left_cols
          _ -> left_cols |> Enum.map(&Enum.drop(&1, 1))
        end

      right_cols =
        case hor_move do
          :yes -> right_cols
          _ -> right_cols |> Enum.map(&Enum.drop(&1, 1))
        end

      updated_processed = MapSet.put(processed, {hor_pos, ver_pos})

      case cell do
        "@" ->
          [
            {:valid_move, {hor_pos, ver_pos}},
            check_move_validity(
              left_cols,
              remaining_cells,
              right_cols,
              {hor_pos, ver_pos + 1},
              :no,
              updated_processed
            )
          ]

        "#" ->
          {:blocked, {hor_pos, ver_pos}}

        "[" ->
          [next_col | remaining_right_cols] = right_cols

          [
            {:valid_move, {hor_pos, ver_pos}},
            check_move_validity(
              left_cols,
              remaining_cells,
              right_cols,
              {hor_pos, ver_pos + 1},
              :no,
              updated_processed
            ),
            check_move_validity(
              left_cols ++ [[cell] ++ remaining_cells],
              next_col,
              remaining_right_cols,
              {hor_pos + 1, ver_pos},
              :yes,
              updated_processed
            )
          ]

        "]" ->
          [prev_col | remaining_left_cols] = left_cols |> Enum.reverse()

          [
            {:valid_move, {hor_pos, ver_pos}},
            check_move_validity(
              left_cols,
              remaining_cells,
              right_cols,
              {hor_pos, ver_pos + 1},
              :no,
              updated_processed
            ),
            check_move_validity(
              Enum.reverse(remaining_left_cols),
              prev_col,
              [[cell] ++ remaining_cells] ++ right_cols,
              {hor_pos - 1, ver_pos},
              :yes,
              updated_processed
            )
          ]

        "." ->
          [{:valid_move, {hor_pos, ver_pos - 1}}]
      end
    end
  end

  # left
  # ][ = O,  [] -, [[ = impossible, ]] = impossible

  # first row is always the one to merge into
  # defp join_rows(row1, row2, :left) do
  #   Enum.zip(row1, row2)
  #   |> Enum.map(fn
  #     {"#", _} -> "#"
  #     {_, "#"} -> "#"
  #     {"]", "["} -> "O"
  #     {"[", "]"} -> "-"
  #     {"[", _} -> "["
  #     {"]", _} -> "]"
  #     {_, "."} -> "."
  #     {".", _} -> "."
  #   end)
  # end

  # right
  # ][ = -,  []  = 0, [[ = impossible, ]] = impossible

  # first row is always the one to merge into
  # defp join_rows(row1, row2, :right) do
  #   Enum.zip(row1, row2)
  # |> Enum.map(fn
  #   {"#", _} -> "#"
  #   {_, "#"} -> "#"
  #   {"[", "]"} -> "O"
  #   {"]", "["} -> "-"
  #   {"]", _} -> "O"
  #   {".", _} -> "."
  #   {_, "."} -> "."
  # end)
  # end

  defp dmove_robot(grid, :down) do
    transposed_grid = transpose_grid(grid)
    {before_robot, robot_row, after_robot} = find_robot_row([], transposed_grid)

    updated_row =
      eliminate_empty_space_before_robot(Enum.reverse(robot_row), 0, [], [])
      |> Enum.reverse()

    (before_robot ++ [updated_row] ++ after_robot) |> transpose_grid()
  end

  defp move_robot(grid, :left) do
    {before_robot, robot_row, after_robot} = find_robot_row([], grid)
    updated_row = eliminate_empty_space_before_robot(robot_row, 0, [], [])
    before_robot ++ [updated_row] ++ after_robot
  end

  defp move_robot(grid, :right) do
    {before_robot, robot_row, after_robot} = find_robot_row([], grid)

    updated_row =
      eliminate_empty_space_before_robot(Enum.reverse(robot_row), 0, [], [])
      |> Enum.reverse()

    before_robot ++ [updated_row] ++ after_robot
  end

  defp move_robot(grid, :up) do
    transposed_grid = transpose_grid(grid)
    {before_robot, robot_row, after_robot} = find_robot_row([], transposed_grid)
    updated_row = eliminate_empty_space_before_robot(robot_row, 0, [], [])
    (before_robot ++ [updated_row] ++ after_robot) |> transpose_grid()
  end

  defp move_robot(grid, :down) do
    transposed_grid = transpose_grid(grid)
    {before_robot, robot_row, after_robot} = find_robot_row([], transposed_grid)

    updated_row =
      eliminate_empty_space_before_robot(Enum.reverse(robot_row), 0, [], [])
      |> Enum.reverse()

    (before_robot ++ [updated_row] ++ after_robot) |> transpose_grid()
  end

  defp eliminate_empty_space_before_robot(["@" | rest], removed_dots, before, _original) do
    before ++ ["@"] ++ List.duplicate(".", removed_dots) ++ rest
  end

  defp eliminate_empty_space_before_robot(["." | rest], removed_dots, before, original) do
    case removed_dots do
      0 -> eliminate_empty_space_before_robot(rest, 1, before, original ++ ["."])
      1 -> eliminate_empty_space_before_robot(rest, 1, original, original ++ ["."])
    end
  end

  defp eliminate_empty_space_before_robot(["#" | rest], _removed_dots, _before, original) do
    eliminate_empty_space_before_robot(rest, 0, original ++ ["#"], original ++ ["#"])
  end

  defp eliminate_empty_space_before_robot([movable | rest], removed_dots, before, original) do
    eliminate_empty_space_before_robot(
      rest,
      removed_dots,
      before ++ [movable],
      original ++ [movable]
    )
  end

  defp find_robot_col(pre, [row_to_look_at | rest]) do
    cond do
      Enum.member?(row_to_look_at, "@") -> {Enum.reverse(pre), row_to_look_at, rest}
      true -> find_robot_row([row_to_look_at | pre], rest)
    end
  end

  defp find_robot_row(pre, [row_to_look_at | rest]) do
    cond do
      Enum.member?(row_to_look_at, "@") -> {Enum.reverse(pre), row_to_look_at, rest}
      true -> find_robot_row([row_to_look_at | pre], rest)
    end
  end

  defp transpose_grid(grid) do
    Enum.zip(grid) |> Enum.map(&Tuple.to_list/1)
  end

  defp get_input(file) do
    File.read!(file)
    |> String.split("\n\n", trim: true)
    |> then(fn [p1, p2] ->
      grid =
        p1
        |> String.split("\n", trim: true)
        |> Enum.map(fn row ->
          row
          |> String.graphemes()
        end)

      moves =
        p2
        |> String.replace("\n", "")
        |> String.graphemes()
        |> Enum.map(fn
          "v" -> :down
          "^" -> :up
          ">" -> :right
          "<" -> :left
        end)

      {grid, moves}
    end)
  end
end
