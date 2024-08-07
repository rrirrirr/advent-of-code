const f = Bun.file("input");

const text = await f.text();

const originalInput = text
  .split("\n")
  .slice(0, -1)
  .map((l) => [...l]);

const input = text
  .split("\n")
  .slice(0, -1)
  .map((l) => [...l]);

const adjacent = [
  [-1, -1],
  [-1, 0],
  [-1, 1],
  [0, -1],
  [0, 1],
  [1, -1],
  [1, 0],
  [1, 1],
];

const symbolPositions = input.reduce((positions, row, rowNumber) => {
  const rowSymbols = row
    .map((char, col) => [char, rowNumber, col])
    .filter(([char, _]) => {
      return !!isNaN(char) && char !== ".";
    })
    .map(([_, row, col]) => [row, col]);
  return [...positions, ...rowSymbols];
}, []);

symbolPositions.forEach(([symbolRow, symbolCol]) => {
  adjacent.forEach(([adjacentRow, adjacentCol]) => {
    if (
      symbolRow + adjacentRow >= 0 &&
      symbolRow + adjacentRow < input.length &&
      symbolCol + adjacentCol < input[0].length &&
      symbolCol + adjacentCol >= 0 &&
      !isNaN(input[symbolRow + adjacentRow][symbolCol + adjacentCol])
    ) {
      input[symbolRow + adjacentRow][symbolCol + adjacentCol] = "X";
      let leftEnd = -1;
      let rightEnd = 1;
      while (
        symbolCol + adjacentCol + leftEnd >= 0 &&
        !isNaN(
          input[symbolRow + adjacentRow][symbolCol + adjacentCol + leftEnd]
        )
      ) {
        input[symbolRow + adjacentRow][symbolCol + adjacentCol + leftEnd] = "X";
        leftEnd--;
      }
      while (
        symbolCol + adjacentCol + rightEnd <
          input[symbolRow + adjacentRow].length &&
        !isNaN(
          input[symbolRow + adjacentRow][symbolCol + adjacentCol + rightEnd]
        )
      ) {
        input[symbolRow + adjacentRow][symbolCol + adjacentCol + rightEnd] =
          "X";
        rightEnd++;
      }
    }
  });
});

const res = [];

input.forEach((row, rowNum) => {
  let started = false;
  row.forEach((col, colNum) => {
    if (input[rowNum][colNum] === "X") {
      if (started) {
        res[res.length - 1] = [
          ...res[res.length - 1],
          originalInput[rowNum][colNum],
        ];
      } else {
        started = true;
        res.push([originalInput[rowNum][colNum]]);
      }
    } else {
      started = false;
    }
  });
});

const resSum = res.reduce((sum, curr, i) => {
  return sum + +curr.join("");
}, 0);

console.log(resSum);
