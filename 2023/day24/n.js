const text = await Bun.file("input")
  .text()
  .then((v) => v.split("\n").filter(Boolean));

const input = text.map((row) => {
  const [positions, velocities] = row
    .split("@")
    .map((part) => part.split(",").map(Number));
  return [positions, velocities];
});

const lowerRange = 200000000000000;
const higherRange = 400000000000000;

let inbounds = 0;

input.forEach(([[x1, y1, z1], [vx1, vy1, vz1]], i) => {
  input.forEach(([[x2, y2, z2], [vx2, vy2, vz2]], j) => {
    if (j <= i) return;
    const det = vx1 * vy2 - vy1 * vx2;

    if (det === 0) {
      return null;
    }

    const t1 = ((x2 - x1) * vy2 - (y2 - y1) * vx2) / det;
    const t2 = ((x2 - x1) * vy1 - (y2 - y1) * vx1) / det;

    if (t1 < 0 || t2 < 0) {
      return null;
    }

    const intersectionX = x1 + vx1 * t1;
    const intersectionY = y1 + vy1 * t1;

    if (
      intersectionX >= lowerRange &&
      intersectionX <= higherRange &&
      intersectionY >= lowerRange &&
      intersectionY <= higherRange
    ) {
      inbounds++;
      // console.log(intersectionX, intersectionY);
    }
  });
});

console.log(inbounds);
