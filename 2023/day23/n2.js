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

const isValidPath = ([y, x]) => {
  return (
    y >= 0 &&
    y < grid.length &&
    x >= 0 &&
    x < grid[0].length &&
    grid[y][x] !== "#"
  );
};

const getNewDirections = (y, x, [cameFromY, cameFromX]) => {
  return directions
    .map(([dy, dx]) => [y + dy, x + dx])
    .filter(isValidPath)
    .filter(([newY, newX]) => !(newY === cameFromY && newX === cameFromX));
};

const end = `${grid.length - 1},${grid[0].length - 2}`;

const junctionsGraph = {
  "0,1": { neighbours: [] },
  [end]: { neightbours: [] },
};

const checkedJunctions = new Set("0,1");

const findNeighbouringJunctions = ([y, x], cameFrom, from, distance) => {
  const key = [y, x].join(",");

  if (key === end) {
    junctionsGraph[from].neighbours.push([key, distance]);
    return;
  }

  const newDirections = getNewDirections(y, x, cameFrom);

  if (newDirections.length > 1) {
    if (!(key in junctionsGraph)) {
      junctionsGraph[key] = { neighbours: [] };
    }

    junctionsGraph[from].neighbours.push([key, distance]);

    if (checkedJunctions.has(key)) return;
    junctionsGraph[key].neighbours.push([from, distance]);
    checkedJunctions.add(key);

    newDirections.forEach(([newY, newX]) => {
      findNeighbouringJunctions([newY, newX], [y, x], key, 1);
    });
  } else if (newDirections.length) {
    findNeighbouringJunctions(newDirections[0], [y, x], from, distance + 1);
  }
};

const findLongestPath = (currentJunction, visitedJunctions, length) => {
  if (currentJunction === end) return length;
  if (visitedJunctions.has(currentJunction)) return false;

  visitedJunctions.add(currentJunction);

  const newWalks = junctionsGraph[currentJunction].neighbours.map(
    ([key, distance]) =>
      findLongestPath(key, new Set(visitedJunctions), distance + length),
  );

  return Math.max(...newWalks.filter(Boolean));
};

findNeighbouringJunctions([0, 1], [0, 0], "0,1", 0);

const res = findLongestPath("0,1", new Set(), 0);
console.log(res);
