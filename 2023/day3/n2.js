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
      return char === "*";
    })
    .map(([_, row, col]) => [row, col]);
  return [...positions, ...rowSymbols];
}, []);

const gearsAdjacentNumbers = symbolPositions.map(([symbolRow, symbolCol]) => {
  const adjacentNumbers = [];
  adjacent.forEach(([adjacentRow, adjacentCol]) => {
    if (
      symbolRow + adjacentRow >= 0 &&
      symbolRow + adjacentRow < input.length &&
      symbolCol + adjacentCol < input[0].length &&
      symbolCol + adjacentCol >= 0 &&
      !isNaN(input[symbolRow + adjacentRow][symbolCol + adjacentCol])
    ) {
      let leftEnd = -1;
      let rightEnd = 1;
      while (
        symbolCol + adjacentCol + leftEnd >= 0 &&
        !isNaN(
          input[symbolRow + adjacentRow][symbolCol + adjacentCol + leftEnd]
        )
      ) {
        leftEnd--;
      }
      while (
        symbolCol + adjacentCol + rightEnd <
          input[symbolRow + adjacentRow].length &&
        !isNaN(
          input[symbolRow + adjacentRow][symbolCol + adjacentCol + rightEnd]
        )
      ) {
        rightEnd++;
      }
      adjacentNumbers.push(
        input[symbolRow + adjacentRow].slice(
          symbolCol + adjacentCol + leftEnd + 1,
          symbolCol + adjacentCol + rightEnd
        )
      );
      input[symbolRow + adjacentRow] = [
        ...input[symbolRow + adjacentRow].slice(
          0,
          leftEnd + symbolCol + adjacentCol + 1
        ),
        ...Array(Math.abs(leftEnd) + rightEnd - 1).fill("X"),
        ...input[symbolRow + adjacentRow].slice(
          rightEnd + symbolCol + adjacentCol,
          input[0].length
        ),
      ];
    }
  });
  return adjacentNumbers;
});

const filteredGears = gearsAdjacentNumbers.filter((g) => g.length === 2);

const res = filteredGears.reduce((tot, g) => {
  return tot + +g[0].join("") * +g[1].join("");
}, 0);

console.log(res);
