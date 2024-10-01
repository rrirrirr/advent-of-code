const input = await Bun.file("input")
  .text()
  .then((v) => v.split(",").filter(Boolean).map(Number));

const days = 256;

const spawns = Array(days + 6).fill(0);

for (let i = 7; i <= days + 6; i++) {
  let newLants = Math.floor(i / 7);
  spawns[i] = newLants;
  for (let j = 1; j < newLants; j++) {
    let idx = i - j * 7 - 2;
    if (idx >= 0) {
      spawns[i] += spawns[idx];
    }
  }
}

const res = input.map((v) => {
  return spawns[days + (6 - v)];
});

console.log(res.reduce((tot, v) => tot + v, 0) + res.length);
