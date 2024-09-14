const readGridFromFile = async (filename) => {
  const content = await Bun.file(filename).text();
  return content
    .trim()
    .split("\n")
    .map((line) => line.split(""));
};

const DIRECTIONS = [
  [1, 0],
  [0, 1],
  [-1, 0],
  [0, -1],
];

const getGridStats = (grid) => ({
  size: grid.flat().filter((c) => c !== "#").length,
  height: grid.length,
  width: grid[0].length,
});

const getArea = (stepsTaken) => Math.ceil((stepsTaken * 2 + 1) ** 2 / 2);

const isValidPosition = (grid, [y, x], gridStats, onEndStep) => {
  const { height, width } = gridStats;
  const ty = ((y % height) + height) % height;
  const tx = ((x % width) + width) % width;
  return grid[ty][tx] !== "#";
};

const calculateUnreachablePlots = (
  cyclesAtStart,
  acc,
  startVal,
  startAcc,
  startSpeed,
  startStones,
) => {
  const getAcc = (c) => {
    const n = c + cyclesAtStart;
    const s = n % 2 ? -1 : 1;
    return -s * startVal + n * -s * Math.abs(acc);
  };

  let a = startAcc;
  let s = startSpeed;
  let t = startStones;
  const cyclesToDo = 26501300 / 131 - cyclesAtStart + 1;

  for (let i = 0; i < cyclesToDo; i++) {
    a += getAcc(i);
    s += a;
    t += s;
  }

  return t;
};

const walk = (grid, start, totalSteps, gridStats) => {
  const queue = [[...start, 0]];
  const cache = new Set();
  const endPoints = new Set();
  const everyCycle = new Set();
  const unreachablesPerCycle = [];
  const acceleration = [0];
  let count = 0;
  let accOfAcc = false;
  let k = false;
  const end = totalSteps % 2;
  const cycle = gridStats.width;

  while (queue.length > 0) {
    const [y, x, stepsTaken] = queue.shift();
    const isOnEndStep = stepsTaken % 2 !== end;
    const key = `${y},${x}`;

    if (stepsTaken % cycle === 66 && !everyCycle.has(stepsTaken - 1)) {
      everyCycle.add(stepsTaken - 1);
      const cyclesDone = Math.floor(stepsTaken / cycle);
      const area = getArea(stepsTaken - 1);
      unreachablesPerCycle.push(area - count);

      const delta = unreachablesPerCycle.at(-1) - unreachablesPerCycle.at(-2);
      const newAcceleration =
        delta - (unreachablesPerCycle.at(-2) - unreachablesPerCycle.at(-3));
      acceleration.push(newAcceleration);

      if (!!Number(newAcceleration - acceleration.at(-3))) {
        accOfAcc = newAcceleration - acceleration.at(-3);
        if (!k) {
          k =
            (acceleration.at(-1) -
              acceleration.at(-2) -
              accOfAcc * cyclesDone) *
            -1;
        }
        return calculateUnreachablePlots(
          cyclesDone,
          accOfAcc,
          k,
          acceleration.at(-2),
          unreachablesPerCycle.at(-2) - unreachablesPerCycle.at(-3),
          unreachablesPerCycle.at(-2),
        );
      }
    }

    if (cache.has(key)) continue;
    cache.add(key);

    if (
      stepsTaken > totalSteps ||
      !isValidPosition(grid, [y, x], gridStats, isOnEndStep)
    ) {
      continue;
    }

    if (isOnEndStep) {
      endPoints.add(`${y},${x}`);
      count++;
    }

    for (const [dy, dx] of DIRECTIONS) {
      queue.push([y + dy, x + dx, stepsTaken + 1]);
    }
  }

  return count;
};

const findStart = (grid) => {
  for (let y = 0; y < grid.length; y++) {
    const x = grid[y].findIndex((c) => c === "S");
    if (x !== -1) return [y, x];
  }
};

const main = async () => {
  const grid = await readGridFromFile("input");
  const gridStats = getGridStats(grid);
  const start = findStart(grid);
  const unreachables = walk(grid, start, 5000, gridStats);
  const res = getArea(26501365) - unreachables;
  console.log(res);
};

main();
