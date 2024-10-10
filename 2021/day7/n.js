const input = await Bun.file("input")
  .text()
  .then((v) => v.split(",").filter(Boolean).map(Number));

const min = Math.min(...input);
const max = Math.max(...input);

const deltas = Array.from({ length: max - min }, (_, i) => {
  const pos = min + i;
  const deltaSum = input.reduce((sum, v) => sum + Math.abs(v - pos), 0);
  return deltaSum;
});

const res = Math.min(...deltas);

console.log(res);
