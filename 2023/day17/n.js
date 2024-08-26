const input = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .slice(0, -1)
      .map((l) => l.split("").map(Number))
  );

const directions = [
  [0, 1, "right"],
  [1, 0, "down"],
  [0, -1, "left"],
  [-1, 0, "up"],
];

const opposite = {
  right: "left",
  down: "up",
  left: "right",
  up: "down",
};

const directionIndex = {
  right: 0,
  down: 1,
  left: 2,
  up: 3,
};

const rows = input.length;
const cols = input[0].length;

const maxCellValue = Math.max(...input.flat());
const maxDistance = maxCellValue * rows * cols;

const buckets = Array.from({ length: maxDistance + 1 }, () => []);
const dist = Array.from({ length: rows }, () =>
  Array.from({ length: cols }, () =>
    Array.from({ length: 4 }, () => Array(4).fill(Infinity))
  )
);

const minimizeHeatLoss = () => {
  const visited = new Set();

  dist[0][0][0][0] = input[0][0];

  buckets[input[0][0]].push([0, 0, 0, "", 0]);

  let currentDistance = 0;

  while (currentDistance <= maxDistance) {
    const bucket = buckets[currentDistance];
    while (bucket.length > 0) {
      const [y, x, distance, lastDirection, stepsInSameDirection] =
        bucket.shift();

      if (x === cols - 1 && y === rows - 1) {
        return distance;
      }

      const key = `${y}-${x}-${lastDirection}-${stepsInSameDirection}`;

      if (visited.has(key)) {
        continue;
      }

      directions
        .filter(([, , d]) => d !== opposite[lastDirection])
        .forEach(([dy, dx, newDirection]) => {
          const newX = x + dx;
          const newY = y + dy;
          const i = directionIndex[newDirection];

          if (newX < 0 || newX >= cols || newY < 0 || newY >= rows) return;

          const newDistance = distance + input[newY][newX];

          const sameDirection = newDirection === lastDirection;

          const newStepsInSameDirection = sameDirection
            ? stepsInSameDirection + 1
            : 1;

          if (
            newStepsInSameDirection > 3 ||
            newDistance > dist[newY][newX][i][newStepsInSameDirection]
          )
            return;

          dist[newY][newX][i][newStepsInSameDirection] = newDistance;

          buckets[newDistance].push([
            newY,
            newX,
            newDistance,
            newDirection,
            newStepsInSameDirection,
          ]);
        });
      visited.add(key);
    }
    currentDistance++;
  }
};

const res = minimizeHeatLoss();
console.log(res);

// console.log(
//   dist
//     .map((row) =>
//       row
//         .map((node) =>
//           node.reduce(
//             (minVal, enteredDirection) =>
//               Math.min(
//                 minVal,
//                 enteredDirection.reduce(
//                   (min, step) => Math.min(min, step),
//                   Infinity
//                 )
//               ),
//             Infinity
//           )
//         )
//         .map((val) => String(val).padStart(3, " ").slice(0, 3))
//         .join(" ")
//     )
//     .join("\n")
// );
