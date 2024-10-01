const input = await Bun.file("input")
  .text()
  .then((v) => v.split(",").filter(Boolean).map(Number));

const spawns = Array(80).fill(0);

for (let i = 6; i <= 32; i++) {
  let res = 0;
  const newLants = Math.floor(i / 6);
  res += newLants;
  if (i === 32) {
    console.log("new", newLants);
  }

  for (let j = 0; j <= newLants; j++) {
    if (i === 32) {
      console.log("n", i - j * 6 - 2);
      console.log("res:", spawns[i - Math.max(j * 6 - 2, 0)]);
    }
    res += spawns[i - Math.max(j * 6 - 2, 0)];
  }

  spawns[i] = res;
}

const res = input.map((v) => {
  return spawns[80 - v];
});

console.log(res.reduce((tot, v) => tot + v, 0));
console.log(spawns);
