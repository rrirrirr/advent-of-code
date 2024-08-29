const toDec = (hex) => {
  return parseInt(hex, 16);
};

const decToDirection = { [0]: "R", [1]: "D", [2]: "L", [3]: "U" };

const input = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .slice(0, -1)
      .map((l) => {
        const [, , color] = l.split(" ");
        const hex = color.replace(/[()#]/g, "");
        const steps = toDec(hex.slice(0, 5));
        const direction = toDec(hex.slice(5));

        return [decToDirection[direction], steps];
      })
  );

const directions = {
  ["R"]: [0, 1],
  ["L"]: [0, -1],
  ["U"]: [-1, 0],
  ["D"]: [1, 0],
};

let position = [1, 1];

const createCorner = ([y, x], [direction, length]) => {
  return [
    y + directions[direction][0] * length,
    x + directions[direction][1] * length,
  ];
};

const corners = input.reduce(
  (acc, instruction) => {
    position = acc.at(-1);
    return [...acc, createCorner(position, instruction)];
  },
  [position]
);

const shoeLace = (corners) => {
  const lace = ([y1, x1], [y2, x2]) => {
    return x1 * y2 - y1 * x2 + Math.abs(y2 - y1) + Math.abs(x2 - x1);
  };

  const laced = corners.reduce((acc, _, i) => {
    if (i === corners.length - 1) return acc;

    return acc + lace(corners[i], corners[i + 1]);
  }, 0);

  return Math.abs(laced) / 2 + 1;
};

console.log(shoeLace(corners));
