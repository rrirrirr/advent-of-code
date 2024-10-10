const input = await Bun.file("input")
  .text()
  .then((v) => v.split(",").filter(Boolean).map(Number));

const min = Math.min(...input);
const max = Math.max(...input);

const costs = Array(max - min).fill(0);

for (let i = 1; i <= max; i++) {
  costs[i] = costs[i - 1] + i;
}

const cost = (v) => costs[v];

const deltas = Array.from({ length: max - min }, (_, i) => {
  const pos = min + i;
  const deltaSum = input.reduce((sum, v) => sum + cost(Math.abs(v - pos)), 0);
  return deltaSum;
});

const res = Math.min(...deltas);

console.log(res);
