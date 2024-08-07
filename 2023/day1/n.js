const f = Bun.file("input");

const input = await f.text();

const words = [
  "one",
  "two",
  "three",
  "four",
  "five",
  "six",
  "seven",
  "eight",
  "nine",
];

const withoutLetters = input
  .split("\n")
  .slice(0, -1)
  .map((l) =>
    words.reduce((replaced, word, num) => {
      return replaced.replaceAll(word, `${word}${num + 1}${word}`);
    }, l)
  )
  .map((l) => [...l].filter(Number))
  .filter((l) => l.length);

console.log(withoutLetters);

const sum = withoutLetters.reduce((total, line) => {
  return Number(line[0] + line.at(-1)) + total;
}, 0);

console.log(sum);
