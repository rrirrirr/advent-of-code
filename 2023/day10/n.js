const f = Bun.file("./input");
const t = await f.text();

const map = t.split("\n").map((r) => r.split(""));

const start = map.reduce(
  (pos, row, i) => {
    if (pos[1] > -1) return pos;

    const c = row.findIndex((c) => c === "S");

    return c > -1 ? [i, c] : pos;
  },
  [-1, -1]
);

const neighbours = [
  [-1, 0],
  [0, -1],
  [0, 1],
  [1, 0],
];

const moves = {
  ["-10"]: ["|", "7", "F"],
  ["0-1"]: ["-", "L", "F"],
  ["01"]: ["-", "7", "J"],
  ["10"]: ["|", "L", "J"],
};

const next = {
  ["|"]: [
    [-1, 0],
    [1, 0],
  ],
  ["-"]: [
    [0, -1],
    [0, 1],
  ],
  ["L"]: [
    [-1, 0],
    [0, 1],
  ],
  ["J"]: [
    [-1, 0],
    [0, -1],
  ],
  ["7"]: [
    [1, 0],
    [0, -1],
  ],
  ["F"]: [
    [1, 0],
    [0, 1],
  ],
  ["."]: [],
  ["S"]: [],
  ["X"]: [],
};

const hasConnection = ([ay, ax], [by, bx]) => {
  // "|" //is a vertical pipe connecting north and south.
  // "-" //is a horizontal pipe connecting east and west.
  // "L" //is a 90-degree bend connecting north and east.
  // "J" //is a 90-degree bend connecting north and west.
  // "7" //is a 90-degree bend connecting south and west.
  // "F" //is a 90-degree bend connecting south and east.
  // "." //is ground; there is no pipe in this tile.
  // "S" //is start
  // const from = map[ay][ax];
  const to = map[ay + by][ax + bx];

  // console.log([by, bx].join(""), to);
  const id = [by, bx].join("");

  return moves[id].includes(to);
};

const [startY, startX] = start;

const initialNeighbours = neighbours
  .filter(([y, x], i) => {
    if (startY + y < 0 || startY + y >= map.length) {
      return false;
    }

    if (startX + x < 0 || startX + x >= map[0].length) {
      return false;
    }

    return hasConnection([startY, startX], [y, x]);
  })
  .map(([y, x]) => [startY + y, startX + x]);

// const queuedNeighbours = console.log(start);

const inbounds = ([y, x]) => {
  return y > -1 && y < map.length && x > -1 && x < map[0].length;
};

let heads = initialNeighbours.map((pos) => ({ pos, dist: 1, todelete: false }));
let max = 0;

while (heads.length) {
  heads = heads
    .map(({ pos, dist }, i) => {
      const [y, x] = pos;
      const symbol = map[y][x];

      // console.log(symbol, y, x, i);

      const nextPos = next[symbol]
        .map(([ny, nx]) => [y + ny, x + nx])
        .filter(inbounds)
        .filter(([y, x]) => map[y][x] !== "X" && map[y][x] !== "S");

      map[y][x] = "X";
      max = Math.max(dist, max);

      // console.log(nextPos);

      if (nextPos.length) {
        // const [dy, dx] = nextPos[0];
        return { pos: nextPos[0], dist: dist + 1, todelete: false };
      }

      return { todelete: true };
    })
    .filter(({ todelete }) => !todelete);
}

console.log(start);

console.log(
  map
    .slice(0, -1)
    .map((l) => l.join(""))
    .join("\n")
);

console.log(max);
