const f = Bun.file("input");
const text = await f.text();

const [t, d] = text.split("\n");

const time = +t.split(" ").slice(1).filter(Boolean).join("");
const distance = +d.split(" ").slice(1).filter(Boolean).join("");

console.log(time, distance);

const timeSeries = Array.from({ length: time }, (_, j) => j);

const wins = timeSeries.filter((held) => (time - held) * held > distance);

console.log(wins.length);
