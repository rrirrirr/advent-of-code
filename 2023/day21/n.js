const grid = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .slice(0, -1)
      .map((l) => l.split("")),
  );

const directions = [
  [1, 0],
  [0, 1],
  [-1, 0],
  [0, -1],
];

const valid = ([y, x]) => {
  if (y < 0) return false;
  if (y > grid.length - 1) return false;
  if (x < 0) return false;
  if (x > grid[0].length - 1) return false;
  if (grid[y][x] === "#") return false;

  return true;
};

const isOccupied = ([y, x]) => {
  return grid[y][x] === "O";
};

const cache = new Set();
const endPoints = new Set();

const walk = ([y, x], stepsTaken = 0) => {
  if (!valid([y, x])) return 0;

  const key = `${y},${x},${stepsTaken}`;
  if (cache.has(key)) return 0;

  if (stepsTaken === 64) {
    if (endPoints.has(`${y},${x}`)) return 0;
    endPoints.add(`${y},${x}`);
    return 1;
  }

  cache.add(key);

  return directions.reduce((acc, [dy, dx]) => {
    return acc + walk([y + dy, x + dx], stepsTaken + 1);
  }, 0);
};

const start = grid
  .map((l, y) => {
    const x = l.findIndex((c) => c === "S");
    return x > -1 ? [y, x] : false;
  })
  .find((l) => l);

const res = walk(start);

// console.log(grid.map((l) => l.join("")).join("\n"));
console.log(res);
