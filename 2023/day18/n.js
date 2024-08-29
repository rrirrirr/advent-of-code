const input = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .slice(0, -1)
      .map((l) => {
        const [direction, steps, color] = l.split(" ");
        return [direction, Number(steps), color.replace(/[()]/g, "")];
      })
  );

const directions = {
  ["R"]: [0, 1],
  ["L"]: [0, -1],
  ["U"]: [-1, 0],
  ["D"]: [1, 0],
};

const directionsA = [
  [0, 1],
  [0, -1],
  [-1, 0],
  [1, 0],
];

let position = [0, 0];

const digged = [];

const createDigs = ([starty, startx], direction, length) => {
  return Array.from({ length: length * 2 }, (_, i) => [
    starty + directions[direction][0] * (i + 1),
    startx + directions[direction][1] * (i + 1),
  ]);
};

input.forEach(([d, l, _]) => {
  digged.push(...createDigs(position, d, l));
  position = digged.at(-1);
});

const minx = digged.reduce((min, [, x]) => Math.min(min, x), Infinity);
const miny = digged.reduce((min, [y, _]) => Math.min(min, y), Infinity);
const maxx = digged.reduce((max, [, x]) => Math.max(max, x), 0);
const maxy = digged.reduce((max, [y, _]) => Math.max(max, y), 0);

const map = Array.from({ length: Math.abs(miny) + maxy + 3 }, () =>
  Array(Math.abs(minx) + maxx + 3).fill(".")
);

const starty = Math.abs(miny) + 1;
const startx = Math.abs(minx) + 1;

digged.forEach(([y, x]) => {
  map[y + starty][x + startx] = "#";
});

const fill = (start) => {
  const stack = [start];

  while (stack.length > 0) {
    const [y, x] = stack.pop();

    if (
      y < 0 ||
      y >= map.length ||
      x < 0 ||
      x >= map[0].length ||
      map[y][x] !== "."
    ) {
      continue;
    }

    map[y][x] = "O";

    directionsA.forEach(([ny, nx]) => {
      stack.push([y + ny, x + nx]);
    });
  }
};

fill([0, 0]);

const rmap = map
  .map((l) => l.filter((_, i) => i % 2 !== 0))
  .filter((_, i) => i % 2 !== 0);

const res = rmap.reduce((tot, l) => {
  return tot + l.filter((c) => c !== "O").length;
}, 0);

// console.log(rmap.map((l) => l.join("")).join("\n"));
console.log(res);
