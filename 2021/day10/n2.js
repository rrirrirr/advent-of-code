const input = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .filter(Boolean)
      .map((line) => line.split("")),
  );

const openings = ["(", "[", "{", "<"];
const closings = { ")": "(", "}": "{", "]": "[", ">": "<" };
const opposite = { "(": ")", "{": "}", "[": "]", "<": ">" };
const score = { ")": 1, "]": 2, "}": 3, ">": 4 };

const res = input
  .map((line) => {
    return line.reduce((opened, char, i) => {
      if (opened === false) return opened;

      if (openings.includes(char)) {
        opened.push(char);
      } else {
        const lastChar = opened.pop();
        if (closings[char] !== lastChar) {
          return false;
        }
      }
      if (i === line.length - 1)
        return opened.map((c) => opposite[c]).reverse();
      return opened;
    }, []);
  })
  .filter(Boolean)
  .map((line) => line.reduce((prod, fac) => prod * 5 + score[fac], 0))
  .sort((a, b) => b - a);

const mid = Math.floor(res.length / 2);
console.log(res[mid]);
