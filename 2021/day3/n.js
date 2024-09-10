const input = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .slice(0, -1)
      .map((v) => v.split("").map(Number)),
  );

const res = input
  .reduce((acc, line) => {
    line.forEach((v, i) => (acc[i] = acc[i] + v));
    return acc;
  }, Array(input[0].length).fill(0))
  .map((v) => Math.floor(v / (input.length / 2)));

const gamma = res.reverse().reduce((tot, v, i) => tot + v * 2 ** i, 0);
const epsilon = res.map((v) => +!v).reduce((tot, v, i) => tot + v * 2 ** i, 0);

console.log(gamma * epsilon);
