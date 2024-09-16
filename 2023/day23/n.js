const text = await Bun.file("input").text();
const grid = text
  .split("\n")
  .filter(Boolean)
  .map((row) => row.split(""));

const directions = [
  [-1, 0],
  [0, 1],
  [1, 0],
  [0, -1],
];

const forcedPaths = {
  "<": [0, -1],
  v: [1, 0],
  ">": [0, 1],
  "^": [1, 0],
};

const isValidPath = ([y, x]) => {
  return (
    y >= 0 &&
    y < grid.length &&
    x >= 0 &&
    x < grid[0].length &&
    grid[y][x] !== "#"
  );
};

const getNewDirections = (y, x, tile) => {
  if (tile in forcedPaths) {
    const [dy, dx] = forcedPaths[tile];
    return [[y + dy, x + dx]].filter(isValidPath);
  }
  return directions.map(([dy, dx]) => [y + dy, x + dx]).filter(isValidPath);
};

const endY = grid.length - 1;
const endX = grid[0].length - 2;
const q = [];

const walk = ([y, x], path) => {
  if (y === endY && x === endX) return path.size;

  const key = [y, x].join(",");
  if (path.has(key)) return false;

  const newPath = new Set(path);
  newPath.add(key);

  const tile = grid[y][x];
  // console.log(y, x, tile);

  const newDirections = getNewDirections(y, x, tile);

  const newWalks = newDirections.map((dir) => walk(dir, newPath));

  return Math.max(...newWalks.filter(Boolean));
};

const res = walk([0, 1], new Set());
console.log(res);
