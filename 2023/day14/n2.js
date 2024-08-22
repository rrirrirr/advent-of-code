const input = await Bun.file("input")
  .text()
  .then(
    (v) =>
      v.split("\n\n").map((n) => {
        const split = n.split("\n").slice(0, -1);
        return split.map((l) => l.split(""));
      })[0]
  );

const transpose = (grid) => {
  return Array.from({ length: grid[0].length }, (c, i) => {
    return [
      ...Array.from({ length: grid.length }, (r, j) => {
        return grid[j].at(i);
      }),
    ];
  });
};

const reverse = (grid) => {
  return grid.map((l) => l.reverse());
};

const moveOs = (grid) => {
  return grid.map(moveOsInCol);
};

const moveOsInCol = (col) => {
  if (!col.length) return [];
  const firstHash = col.findIndex((c) => c === "#");
  const end = firstHash >= 0 ? Math.max(1, firstHash) : col.length;
  const part = col.slice(0, end);
  const rest = col.slice(end);

  const os = part.filter((c) => c === "O").length;
  const dots = part.filter((c) => c === ".").length;
  const hash = part.filter((c) => c === "#").length;

  return [
    ...Array(os).fill("O"),
    ...Array(dots).fill("."),
    ...Array(hash).fill("#"),
    ...moveOsInCol(rest),
  ];
};

const operations = [
  transpose,
  moveOs,
  transpose,
  moveOs,
  transpose,
  reverse,
  moveOs,
  reverse,
  transpose,
  reverse,
  moveOs,
  reverse,
];

let res = input;
let found = 0;
let cycle = false;
let left = 0;

const cache = new Map();

for (let i = 0; i < 1000000000; i++) {
  const key = JSON.stringify(res);
  if (cache.has(key)) {
    cycle = i - cache.get(key);
    left = (1000000000 - i) % cycle;
    break;
  } else {
    res = operations.reduce((grid, fn) => fn(grid), res);
    cache.set(key, i);
  }
}

for (let i = 0; i < left; i++) {
  res = operations.reduce((grid, fn) => fn(grid), res);
}

const length = res[0].length;

const v = transpose(res)
  .map((col) =>
    col
      .map((c, i) => (c === "O" ? length - i : c))
      .filter(Number)
      .reduce((tot, n) => tot + n, 0)
  )
  .reduce((tot, n) => tot + n, 0);

// console.log(res.join("\n").replaceAll(",", ""));
console.log(v);
