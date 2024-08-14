const f = Bun.file("./input");
const t = await f.text();

const split = t.split("\n").slice(0, -1);

const dotRows = split
  .map((r) => [...r])
  .map((row) => {
    return row.every((c) => c === ".") ? Array(row.length).fill("*") : row;
  });

const dotColumns = dotRows[0].map((_, i) => {
  const isVerticalDotColumn = dotRows.every((_, j) =>
    [".", "*"].includes(dotRows[j][i])
  );
  return isVerticalDotColumn ? i : false;
});

const map = dotRows.map((row, i) => {
  return row.map((c, j) => {
    return !dotColumns.includes(j) ? c : c === "*" ? "-" : "*";
  });
});

const stars = map.reduce((acc, row, i) => {
  const rowstars = row.reduce((acc, c, j) => {
    return c === "#" ? [...acc, [i, j]] : acc;
  }, []);
  return [...acc, ...rowstars];
}, []);

const pairs = stars.flatMap((c, i) => {
  return stars.slice(i + 1).map((c2) => [c, c2]);
});

const getWeight = (cell) => {
  if (cell === ".") return 1;
  if (cell === "#") return 1;
  if (cell === "*") return 1000000;
  if (cell === "-") return 2000000;
  return Infinity;
};

const dijkstra = (grid, [sy, sx], [gy, gx]) => {
  const directions = [
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0],
  ];

  const rows = grid.length;
  const cols = grid[0].length;

  const dist = Array.from({ length: rows }, () => Array(cols).fill(Infinity));
  const pq = [];
  dist[sy][sx] = 0;
  pq.push([sy, sx]);

  while (pq.length) {
    const [currentY, currentX] = pq.shift();

    if (currentY === gy && currentX === gx) {
      return dist[currentY][currentX]; // Shortest path to the goal
    }

    const next = directions.forEach(([dy, dx]) => {
      const newY = currentY + dy;
      const newX = currentX + dx;

      if (newY >= 0 && newY < rows && newX >= 0 && newX < cols) {
        const weight = getWeight(grid[newY][newX]);
        const newDist = dist[currentY][currentX] + weight;

        if (newDist < dist[newY][newX]) {
          dist[newY][newX] = newDist;
          pq.push([newY, newX]);
        }
      }
    });
  }

  return -1;
};

console.log(pairs.length);

const walks = pairs.map(([s1, s2], i) => {
  console.log(i);
  return dijkstra(map, s1, s2);
});

const res = walks.reduce((acc, l) => acc + l, 0);

console.log(res);
