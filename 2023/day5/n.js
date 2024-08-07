const f = Bun.file("input");
const text = await f.text(f);

const lines = text.split("\n\n").map((l) =>
  l
    .split(":")[1]
    .trim()
    .split("\n")
    .map((m) => m.split(" ").map(Number))
);

const [seeds, ...rest] = lines;

const res = rest.reduce((remainder, map) => {
  return remainder.map((remain) => {
    const change = map.find(
      ([_, sourceStart, rangeLength]) =>
        remain >= sourceStart && remain <= sourceStart + rangeLength
    );

    return !!change ? change[0] + (remain - change[1]) : remain;
  });
}, seeds[0]);

console.log(Math.min(...res));
