const f = Bun.file("./input");
const t = await f.text();
const [rawinstructions, rawmap] = t.split("\n\n");

const instructions = rawinstructions.split("");

const m = rawmap.split("\n").slice(0, -1);
const map = m.reduce((acc, curr) => {
  const [node, directions] = curr.split(" = ");
  const [left, right] = directions.replace(/[(),]/g, "").split(" ");

  acc[node] = {};

  acc[node].L = left;
  acc[node].R = right;

  return acc;
}, {});

const starts = m
  .filter((l) => {
    const endingChar = l.split(" ")[0].at(-1);
    return endingChar === "A";
  })
  .map((l) => l.split(" ")[0]);

const endsWithZ = (n) => {
  return n.at(-1) === "Z";
};

const cycles = starts.map((start) => {
  let currentPos = start;
  const cycles = new Set();
  const ns = [];

  let i = 0;
  let j = 0;

  while (!cycles.has(currentPos)) {
    if (endsWithZ(currentPos)) {
      cycles.add(currentPos);
      ns.push(i);
    }

    currentPos = map[currentPos][instructions[j]];

    i++;
    j = i % instructions.length;
  }

  ns.push(i);

  return ns[0];
});

const gcd = (a, b) => {
  if (!b) {
    return a;
  }
  return gcd(b, a % b);
};

const lcm = (a, b) => {
  return Math.abs(a * b) / gcd(a, b);
};

const res = cycles.reduce((acc, num) => lcm(acc, num));

console.log(res);
