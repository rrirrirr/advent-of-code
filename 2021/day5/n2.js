const text = await Bun.file("input").text();
const input = text
  .split("\n")
  .filter(Boolean)
  .map((line) => line.split(" -> ").map((part) => part.split(",").map(Number)));

const positions = {};

const addToPos = (x, y) => {
  const key = `${x},${y}`;
  if (!positions[key]) {
    positions[key] = 0;
  }
  positions[key] = positions[key] + 1;
};

input.forEach(([[x1, y1], [x2, y2]]) => {
  if (x1 === x2) {
    const min = Math.min(y1, y2);
    const max = Math.max(y1, y2);
    for (let i = min; i <= max; i++) {
      addToPos(x1, i);
    }
    return;
  }
  if (y1 === y2) {
    const min = Math.min(x1, x2);
    const max = Math.max(x1, x2);
    for (let i = min; i <= max; i++) {
      addToPos(i, y1);
    }
    return;
  }
  const minX = Math.min(x1, x2);
  const maxX = Math.max(x1, x2);
  const signX = Math.sign(x2 - x1);
  const signY = Math.sign(y2 - y1);

  for (let i = 0; i <= maxX - minX; i++) {
    addToPos(x1 + signX * i, y1 + signY * i);
  }
});

const res = Object.values(positions).filter((v) => v > 1).length;
console.log(res);
