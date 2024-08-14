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

const expandMap = () => {
  const expansionHorizontal = {
    ["-"]: ["-", "-", "-"],
    ["."]: [".", ".", "."],
    ["|"]: [".", "|", "."],
    ["7"]: ["-", "7", "."],
    ["L"]: [".", "L", "-"],
    ["F"]: [".", "F", "-"],
    ["J"]: ["-", "J", "."],
  };

  const expansionVertical = {
    ["-"]: [".", "-", "."],
    ["."]: [".", ".", "."],
    ["|"]: ["|", "|", "|"],
    ["7"]: [".", "7", "|"],
    ["L"]: ["|", "L", "."],
    ["F"]: [".", "F", "|"],
    ["J"]: ["|", "J", "."],
  };

  return map
    .map((row) => {
      return row.reduce((acc, node) => {
        const exp = expansionHorizontal[node];

        return [...acc, ...exp];
      }, []);
    })
    .reduce((acc, row) => {
      const upper = [];
      const normal = [];
      const lower = [];

      row.forEach((c) => {
        const [u, n, l] = expansionVertical[c];
        upper.push(u);
        normal.push(n);
        lower.push(l);
      });

      return [...acc, upper, normal, lower];
    }, []);
};

const reduceMap = (expandedMap) => {
  return expandedMap.reduce((acc, _, index) => {
    if (index % 3 === 0) {
      const normalRow = expandedMap[index + 1];
      acc.push(normalRow.filter((_, i) => i % 3 === 1));
    }
    return acc;
  }, []);
};

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
  ["O"]: [],
};

const hasConnection = ([ay, ax], [by, bx]) => {
  const to = map[ay + by][ax + bx];

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
  .map(([y, x]) => [y, x]);

// const queuedNeighbours = console.log(start);

const inbounds = ([y, x]) => {
  return y > -1 && y < map.length && x > -1 && x < map[0].length;
};

const replaceS = ([sy, sx], neighbours) => {
  const replaceMap = {
    ["0110"]: "F",
    ["1001"]: "F",
    ["0-101"]: "-",
    ["010-1"]: "-",
    ["-1010"]: "|",
    ["10-10"]: "|",
    ["-100-1"]: "J",
    ["0-1-10"]: "J",
    ["100-1"]: "7",
    ["0-110"]: "7",
    ["-1001"]: "L",
    ["01-10"]: "L",
  };

  map[sy][sx] = replaceMap[neighbours.join("").replaceAll(",", "")];
};

replaceS(start, initialNeighbours);

const floodFill = ([y, x], map) => {
  const rows = map.length;
  const cols = map[0].length;
  const visited = Array.from({ length: rows }, () => Array(cols).fill(false));

  const inBounds = (y, x) => {
    return y >= 0 && y < rows && x >= 0 && x < cols;
  };

  const queue = [[y, x]];

  while (queue.length > 0) {
    const [cy, cx] = queue.shift();

    if (!inBounds(cy, cx) || visited[cy][cx]) {
      continue;
    }

    visited[cy][cx] = true;
    map[cy][cx] = "O";

    const nextNodes = neighbours
      .filter(([dy, dx]) => {
        const ny = cy + dy;
        const nx = cx + dx;

        return inBounds(ny, nx) && !visited[ny][nx] && map[ny][nx] !== "X";
      })
      .map(([dy, dx]) => [cy + dy, cx + dx]);

    queue.push(...nextNodes);
  }
};

const expandedMap = expandMap();

let heads = initialNeighbours.map(([y, x]) => ({
  pos: [startY * 3 + 1 + y, startX * 3 + 1 + x],
  dist: 1,
  todelete: false,
}));

expandedMap[startY * 3 + 1][startX * 3 + 1] = "X";

while (heads.length) {
  heads = heads
    .map(({ pos, dist }, i) => {
      const [y, x] = pos;
      const symbol = expandedMap[y][x];

      const nextPos = next[symbol]
        .map(([ny, nx]) => [y + ny, x + nx])
        .filter(([y, x]) => expandedMap[y][x] !== "X");

      expandedMap[y][x] = "X";

      if (nextPos.length) {
        return { pos: nextPos[0], dist: dist + 1, todelete: false };
      }

      return { todelete: true };
    })
    .filter(({ todelete }) => !todelete);
}

floodFill([0, 0], expandedMap);

const reducedMap = reduceMap(expandedMap);

const resMap = reducedMap.map((row) => {
  return row.map((c) => (["X", "O"].includes(c) ? c : "I"));
});

const res = resMap.reduce((tot, row) => {
  return tot + row.filter((c) => c === "I").length;
}, 0);

console.log(
  reducedMap
    .slice(0, -1)
    .map((l) => l.join(""))
    .join("\n")
);

console.log(res);
