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
  const horizontalWin = board.some((line) => line.every((n) => n === "X"));

  // Check columns
  const transposedBoard = transpose(board);
  const verticalWin = transposedBoard.some((line) =>
    line.every((n) => n === "X"),
  );

  // Optionally check diagonals
  // const mainDiagonal = board.every((row, i) => row[i] === "X");
  // const antiDiagonal = board.every((row, i) => row[row.length - 1 - i] === "X");
  // return mainDiagonal || antiDiagonal;
  return horizontalWin || verticalWin;
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

let lastNumber = 0;
let winningBoard = -1;

let boardsLeft = boards;
let lastBoard = null;

while (boardsLeft.length > 0) {
  lastNumber = numbers.shift();
  checkBoards(lastNumber, boards);

  boardsLeft = boardsLeft.filter((board) => {
    return !checkForWin(board);
  });

  if (boardsLeft.length === 1) lastBoard = boardsLeft[0];
}

const sum = lastBoard.reduce(
  (tot, line) =>
    tot + line.reduce((lineTot, n) => lineTot + (n === "X" ? 0 : n), 0),
  0,
);

const res = sum * lastNumber;
console.log(res);
