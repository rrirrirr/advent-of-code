const input = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .filter(Boolean)
      .map((line) => line.split("").map(Number)),
  );

const adjacent = [
  [-1, 0],
  [0, 1],
  [1, 0],
  [0, -1],
];

const isLowPoint = ([y, x]) => {
  const val = input[y][x];

  const neighbours = adjacent
    .map(([ay, ax]) => [y + ay, ax + x])
    .filter(
      ([ny, nx]) =>
        ny >= 0 && ny < input.length && nx >= 0 && nx < input[0].length,
    );

  return neighbours.every(([ny, nx]) => input[ny][nx] > val) ? val + 1 : 0;
};

const res = input
  .flat()
  .map((_, i) => {
    return isLowPoint([Math.floor(i / input[0].length), i % input[0].length]);
  })
  .reduce((tot, v) => tot + v, 0);

console.log(res);
