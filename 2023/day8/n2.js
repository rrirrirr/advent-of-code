const f = Bun.file("./input");
const t = await f.text();

const series = t
  .split("\n")
  .slice(0, -1)
  .map((l) => l.split(" ").map(Number));

const ss = series.map((s) => {
  const levels = [s.slice()];
  let currentLevel = 0;

  while (levels[currentLevel].some(Boolean)) {
    const newLevel = levels[currentLevel].slice(1).map((n, i) => {
      return n - levels[currentLevel][i];
    });

    levels.push(newLevel);
    currentLevel++;
  }

  return levels.reverse();
});

const values = ss.reduce(
  (acc, series) =>
    acc +
    series.reduce((toAdd, s) => {
      return s[0] - toAdd;
    }, 0),
  0
);

console.log(values);
