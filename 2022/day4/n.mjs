import { readFileSync } from "node:fs";

const rawinput = readFileSync("./input", { encoding: "utf8", flag: "r" });
const lines = rawinput.split("\n");

const input = lines.slice(0, -1).map((line) => {
  const [elf1, elf2] = line.split(",");
  return [elf1.split("-").map(Number), elf2.split("-").map(Number)];
});

const isInOther = (elf1start, elf1end, elf2start, elf2end) => {
  if (elf2start > elf1end) return 0;
  if (elf2start < elf1start) return 0;
  if (elf2end > elf1end) return 0;
  if (elf2end < elf1start) return 0;

  return 1;
};

const res = input.reduce((total, pair) => {
  const [[elf1start, elf1end], [elf2start, elf2end]] = pair;

  const res = Math.min(
    isInOther(elf1start, elf1end, elf2start, elf2end) +
      isInOther(elf2start, elf2end, elf1start, elf1end),
    1
  );

  return total + res;
}, 0);

console.log(res);
