const parseInput = async (filePath) => {
  const text = await Bun.file(filePath).text();
  return text
    .split("\n")
    .filter(Boolean)
    .map((line) => line.split("").map(Number));
};

const adjacent = [
  [-1, 0],
  [-1, 1],
  [0, 1],
  [1, 1],
  [1, 0],
  [1, -1],
  [0, -1],
  [-1, -1],
];

const isInBounds =
  (grid) =>
  ([y, x]) =>
    y >= 0 && y < grid.length && x >= 0 && x < grid[0].length;

const increaseEnergy = (grid) => grid.map((row) => row.map((cell) => cell + 1));

const getFlashingPoints = (grid, flashedPositions) =>
  grid
    .flatMap((row, y) =>
      row.map((val, x) => {
        const posKey = `${y},${x}`;
        return val > 9 && !flashedPositions.has(posKey) ? [y, x] : null;
      }),
    )
    .filter(Boolean);

const getAdjacentPoints = (point, grid) =>
  adjacent
    .map(([dy, dx]) => [point[0] + dy, point[1] + dx])
    .filter(isInBounds(grid));

const updateGridPoint = (grid, [y, x], value) => {
  const newGrid = grid.map((row) => [...row]);
  newGrid[y][x] = value;
  return newGrid;
};

const flash = (flashPoints, grid, flashedPositions) => {
  let updatedGrid = [...grid.map((row) => [...row])];
  flashPoints.forEach((point) => {
    flashedPositions.add(`${point[0]},${point[1]}`);
    getAdjacentPoints(point, grid).forEach(([y, x]) => {
      updatedGrid = updateGridPoint(updatedGrid, [y, x], updatedGrid[y][x] + 1);
    });
  });
  return updatedGrid;
};

const resetFlashes = (grid) =>
  grid.map((row) => row.map((cell) => (cell > 9 ? 0 : cell)));

const step = (grid) => {
  const energizedGrid = increaseEnergy(grid);
  const flashedPositions = new Set();

  const processFlashes = (currentGrid) => {
    const flashPoints = getFlashingPoints(currentGrid, flashedPositions);
    if (flashPoints.length === 0) return currentGrid;
    const flashedGrid = flash(flashPoints, currentGrid, flashedPositions);
    return processFlashes(flashedGrid);
  };

  const flashedGrid = processFlashes(energizedGrid);
  return [resetFlashes(flashedGrid), flashedPositions.size];
};

const run = (stepsLeft, grid, totalFlashes = 0) => {
  if (stepsLeft === 0) return totalFlashes;

  // console.log("Steps left:", stepsLeft);
  // console.log(grid.map((row) => row.join("")).join("\n"));
  // console.log("---");

  const [newGrid, flashesThisStep] = step(grid);
  return run(stepsLeft - 1, newGrid, totalFlashes + flashesThisStep);
};

const main = async () => {
  const grid = await parseInput("input");
  const steps = 100;
  const totalFlashes = run(steps, grid, 0);
  console.log("Total flashes:", totalFlashes);
  return totalFlashes;
};

main().catch(console.error);
