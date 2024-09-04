const input = await Bun.file("input")
  .text()
  .then((v) => v.split("\n").map(Number));

const res = input.reduce((tot, val, i, arr) => {
  if (i === 0) return 0;

  return tot + +(val > arr[i - 1]);
}, 0);

console.log(res);
