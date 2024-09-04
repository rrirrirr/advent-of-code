const input = await Bun.file("input")
  .text()
  .then((v) => v.split("\n").map(Number));

const res = input.reduce((tot, _, i, arr) => {
  if (i === 0) return tot;

  const val = arr.slice(i, i + 3).reduce((acc, curr) => acc + curr);
  const prevVal = arr.slice(i - 1, i + 2).reduce((acc, curr) => acc + curr);

  return tot + +(val > prevVal);
}, 0);

console.log(res);
