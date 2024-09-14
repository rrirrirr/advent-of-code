const input = await Bun.file("input")
  .text()
  .then((v) => v.split("\n").filter(Boolean));

const bricks = input.map((str) =>
  str.split("~").map((end) => end.split(",").map(Number)),
);

const generatePositions = ([[ax, ay, az], [bx, by, bz]]) => {
  const xs = Array.from({ length: bx - ax + 1 }, (_, i) => ax + i);
  const ys = Array.from({ length: by - ay + 1 }, (_, i) => ay + i);
  const zs = Array.from({ length: bz - az + 1 }, (_, i) => az + i);
  return zs.flatMap((z) => ys.flatMap((y) => xs.map((x) => [x, y, z])));
};

let brickPositions = bricks.map(generatePositions);

const simulateFalling = (brickPositions) => {
  const occupied = new Set(
    brickPositions.flatMap((positions) =>
      positions.map((position) => position.join(",")),
    ),
  );

  let moved;
  do {
    moved = false;
    brickPositions = brickPositions.map((positions) => {
      const oldPositions = positions.map((p) => p.join(","));
      oldPositions.forEach((p) => occupied.delete(p));

      const canFall = positions.every(
        ([x, y, z]) => z > 1 && !occupied.has(`${x},${y},${z - 1}`),
      );

      if (canFall) {
        moved = true;
        const newPositions = positions.map(([x, y, z]) => [x, y, z - 1]);
        newPositions.forEach((p) => occupied.add(p.join(",")));
        return newPositions;
      } else {
        oldPositions.forEach((p) => occupied.add(p));
        return positions;
      }
    });
  } while (moved);

  return brickPositions;
};

brickPositions = simulateFalling(brickPositions);

const countDisintegrableBricks = (brickPositions) => {
  const occupied = new Set(
    brickPositions.flatMap((positions) =>
      positions.map((position) => position.join(",")),
    ),
  );

  return brickPositions.filter((brick, i) => {
    brick.forEach((position) => occupied.delete(position.join(",")));
    const causesMovement = brickPositions
      .filter((_, j) => i !== j)
      .some((positions) => {
        positions.forEach((position) => occupied.delete(position.join(",")));
        const canFall = positions.every(
          ([x, y, z]) => z !== 1 && !occupied.has([x, y, z - 1].join(",")),
        );
        positions.forEach((position) => occupied.add(position.join(",")));
        return canFall;
      });
    brick.forEach((position) => occupied.add(position.join(",")));
    return !causesMovement;
  }).length;
};

console.log(countDisintegrableBricks(brickPositions));
