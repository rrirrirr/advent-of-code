const input = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .slice(0, -1)
      .map((l) => l.split(""))
  );

const directions = ["up", "right", "down", "left"];

const directionsMap = {
  up: [-1, 0],
  right: [0, 1],
  down: [1, 0],
  left: [0, -1],
};

const opposite = { up: "down", left: "right", right: "left", down: "up" };

const getNewDirections = (from, symbol) => {
  return directions.filter((direction) => {
    if (direction === from) return false;

    if (symbol === "|") {
      return direction === "up" || direction === "down";
    }

    if (symbol === "-") {
      return direction === "right" || direction === "left";
    }

    if (symbol === "\\") {
      if (from === "left") {
        return direction === "down";
      }
      if (from === "down") {
        return direction === "left";
      }
      if (from === "right") {
        return direction === "up";
      }
      if (from === "up") {
        return direction === "right";
      }
      return false;
    }

    if (symbol === "/") {
      if (from === "left") {
        return direction === "up";
      }
      if (from === "down") {
        return direction === "right";
      }
      if (from === "right") {
        return direction === "down";
      }
      if (from === "up") {
        return direction === "left";
      }
      return false;
    }

    // should be a '.'
    return true;
  });
};

const map = input.map((l, y) => {
  return l.map((node, x) => {
    const newNode = { symbol: node, pathed: new Set(), active: false };

    directions.forEach((from) => {
      newNode[from] = getNewDirections(from, newNode.symbol).map((d) => [
        d,
        [y + directionsMap[d][0], x + directionsMap[d][1]],
      ]);
    });
    return newNode;
  });
});

const traverse = (direction, node) => {
  const from = opposite[direction];

  if (node.pathed.has(from)) return 0;

  const toAdd = +!node.active;

  node.pathed.add(from);
  node.active = true;

  const next = node[from].find(([d, _]) => d === direction);

  if (!next) {
    const directions = node[from];
    return (
      toAdd +
      directions.reduce((tot, [dir, [ny, nx]]) => {
        if (ny < 0 || ny >= input.length || nx < 0 || nx >= input[0].length)
          return tot;
        return tot + traverse(dir, map[ny][nx]);
      }, 0)
    );
  }

  const [_, [ny, nx]] = next;
  if (ny < 0 || ny >= input.length || nx < 0 || nx >= input[0].length)
    return toAdd;

  return toAdd + traverse(direction, map[ny][nx]);
};

const starts = [
  ...input[0].map((_, i) => ["down", map[0][i]]),
  ...input[0].map((_, i) => ["up", map[input.length - 1][i]]),
  ...input.map((_, i) => ["right", map[i][0]]),
  ...input.map((_, i) => ["left", map[input[0].length - 1][i]]),
];

const resetMap = () => {
  map.forEach((r, y) =>
    r.forEach((_, x) => {
      map[y][x].pathed = new Set();
      map[y][x].active = false;
    })
  );
};

const res = starts.reduce((max, start) => {
  resetMap();
  const r = traverse(...start);
  return Math.max(max, r);
}, 0);
