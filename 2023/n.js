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

const start = "AAA";
const end = "ZZZ";

let currentPos = start;
let i = 0;
let j = 0;

while (currentPos !== end) {
  currentPos = map[currentPos][instructions[j]];
  i++;
  j = i % instructions.length;
}

console.log(i);
