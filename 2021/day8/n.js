const lines = await Bun.file("input")
  .text()
  .then((v) => v.split("\n").filter(Boolean));

const lengthsToLookFor = [2, 4, 3, 7];

const outputLines = lines
  .map((line) => line.split("|")[1])
  .map((line) => line.split(" "));

const res = outputLines
  .map((line) =>
    line.map((word) => word.length).filter((l) => lengthsToLookFor.includes(l)),
  )
  .map((line) => line.length)
  .reduce((tot, v) => tot + v, 0);

console.log(res);
