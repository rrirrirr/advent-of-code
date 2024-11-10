defmodule Day04 do
  def part1(file) do
    {numbers, boards} = parse_input(file)

    {winning_board, winning_number} = play_bingo(numbers, boards)
    calculate_score(winning_board, winning_number)
  end

  def part2(file) do
    {numbers, boards} = parse_input(file)

    {last_board, last_number} = play_bingo_until_last(numbers, boards)
    calculate_score(last_board, last_number)
  end

  defp parse_input(file) do
    [numbers | boards] =
      file
      |> File.read!()
      |> String.split("\n\n")

    numbers = String.split(numbers, ",")
    boards = Enum.map(boards, &create_board/1)

    {numbers, boards}
  end

  defp create_board(board_string) do
    rows = parse_rows(board_string)
    columns = transpose(rows)
    rows ++ columns
  end

  defp parse_rows(board_string) do
    board_string
    |> String.split("\n")
    |> Enum.map(&parse_row/1)
    |> Enum.filter(&(length(&1) > 0))
  end

  defp parse_row(line) do
    line
    |> String.split(" ")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&{&1, :unmarked})
  end

  defp transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp play_bingo(numbers, boards) do
    Enum.reduce_while(numbers, boards, fn number, current_boards ->
      new_boards = mark_number(current_boards, number)

      case find_winning_board(new_boards) do
        nil -> {:cont, new_boards}
        winning_board -> {:halt, {winning_board, number}}
      end
    end)
  end

  defp play_bingo_until_last(numbers, boards) do
    Enum.reduce(numbers, {nil, boards, nil}, fn number,
                                                {last_winner, current_boards, last_number} ->
      new_boards = mark_number(current_boards, number)
      winning_boards = filter_winning_boards(new_boards)
      remaining_boards = filter_non_winning_boards(new_boards)

      case {winning_boards, remaining_boards} do
        {[], _} -> {last_winner, new_boards, last_number}
        {winners, []} -> {List.last(winners), [], number}
        {winners, rest} -> {List.last(winners), rest, number}
      end
    end)
    |> then(fn {board, _boards, number} -> {board, number} end)
  end

  defp mark_number(boards, number) do
    Enum.map(boards, fn board ->
      board
      |> List.flatten()
      |> Enum.map(fn
        {n, _} when n == number -> {n, :marked}
        other -> other
      end)
      |> Enum.chunk_every(5)
    end)
  end

  defp find_winning_board(boards) do
    Enum.find(boards, &winning_board?/1)
  end

  defp filter_winning_boards(boards) do
    Enum.filter(boards, &winning_board?/1)
  end

  defp filter_non_winning_boards(boards) do
    Enum.reject(boards, &winning_board?/1)
  end

  defp winning_board?(board) do
    Enum.any?(board, &line_complete?/1)
  end

  defp line_complete?(line) do
    Enum.all?(line, fn {_, mark} -> mark == :marked end)
  end

  defp calculate_score(board, number) do
    board
    |> Enum.take(5)
    |> List.flatten()
    |> Enum.filter(fn {_, mark} -> mark == :unmarked end)
    |> Enum.map(fn {num, _} -> String.to_integer(num) end)
    |> Enum.sum()
    |> Kernel.*(String.to_integer(number))
  end
end
