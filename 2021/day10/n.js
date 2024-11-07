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
const score = { ")": 3, "]": 57, "}": 1197, ">": 25137 };

const res = input
  .map((line) => {
    return line.reduce((opened, char) => {
      if (Number(opened)) return opened;

      if (openings.includes(char)) {
        opened.push(char);
      } else {
        const lastChar = opened.pop();
        if (closings[char] !== lastChar) {
          return score[char];
        }
      }
      return opened;
    }, []);
  })
  .filter(Number)
  .reduce((tot, v) => tot + v, 0);

console.log(res);
