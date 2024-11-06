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

const isInbounds = ([y, x]) => {
  return y >= 0 && y < input.length && x >= 0 && x < input[0].length;
};

const isLowPoint = ([y, x]) => {
  const val = input[y][x];

  const neighbours = adjacent
    .map(([ay, ax]) => [y + ay, ax + x])
    .filter(isInbounds);

  return neighbours.every(([ny, nx]) => input[ny][nx] > val) ? [y, x] : false;
};

const travel = ([y, x], lastVal, visited) => {
  const key = `${y},${x}`;
  if (visited.has(key)) return;
  if (!isInbounds([y, x])) return;
  const val = input[y][x];
  if (val === 9) return;
  if (val < lastVal) return;
  visited.add(key);

  adjacent.forEach(([ny, nx]) => travel([y + ny, x + nx], val, visited));
};

const basins = input
  .flat()
  .map((_, i) => {
    return isLowPoint([Math.floor(i / input[0].length), i % input[0].length]);
  })
  .filter(Boolean);

const res = basins
  .map(([y, x]) => {
    const visited = new Set();
    const val = input[y][x];
    travel([y, x], val, visited);
    return visited.size;
  })
  .sort((a, b) => b - a)
  .slice(0, 3)
  .reduce((prod, size) => prod * size, 1);

console.log(res);
