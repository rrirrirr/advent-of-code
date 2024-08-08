const f = Bun.file("input");
const text = await f.text();

const [t, d] = text.split("\n");

const time = t.split(" ").slice(1).filter(Boolean).map(Number);
const distance = d.split(" ").slice(1).filter(Boolean).map(Number);

const winningCombos = time.map((time, i) => {
  const timeSeries = Array.from({ length: time }, (_, j) => j);

  const wins = timeSeries.filter((held) => (time - held) * held > distance[i]);

  return wins.length;
});

const res = winningCombos.reduce((sum, n) => n * sum);

console.log(res);
