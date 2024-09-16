const input = await Bun.file("input").text();
const [rawNumbers, ...rawBoards] = input.split("\n\n");
const numbers = rawNumbers.split(",").map(Number);
const boards = rawBoards.map((board) =>
  board
    .split("\n")
    .filter(Boolean)
    .map((line) => line.split(" ").filter(Boolean).map(Number)),
);

const transpose = (board) => {
  return board[0].map((_, colIndex) => board.map((row) => row[colIndex]));
};

const checkForWin = (board) => {
  // Check rows
  const horizontalWin = board.findIndex((line) => line.every((n) => n === "X"));
  if (horizontalWin >= 0) return true;

  // Check columns
  const transposedBoard = transpose(board);
  const verticalWin = transposedBoard.findIndex((line) =>
    line.every((n) => n === "X"),
  );
  if (verticalWin >= 0) return true;

  // Optionally check diagonals
  // const mainDiagonal = board.every((row, i) => row[i] === "X");
  // const antiDiagonal = board.every((row, i) => row[row.length - 1 - i] === "X");
  // return mainDiagonal || antiDiagonal;
  return false;
};

const checkBoards = (number, boards) => {
  boards.forEach((board) =>
    board.forEach((line, i) =>
      line.forEach((boardNumber, j) => {
        if (boardNumber === number) {
          board[i][j] = "X";
        }
      }),
    ),
  );
};

let winningNumber = 0;
let winningBoard = -1;

for (const number of numbers) {
  checkBoards(number, boards);
  const wonIndex = boards.findIndex(checkForWin);
  if (wonIndex >= 0) {
    winningNumber = number;
    winningBoard = wonIndex;
    break;
  }
}

const sum = boards[winningBoard].reduce(
  (tot, line) =>
    tot + line.reduce((lineTot, n) => lineTot + (n === "X" ? 0 : n), 0),
  0,
);
const res = sum * winningNumber;
console.log(res);
