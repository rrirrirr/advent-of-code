const input = await Bun.file("input")
  .text()
  .then((v) => v.replaceAll("\n", "").split(","));

const HASH = (str) => {
  return str.split("").reduce((tot, c) => {
    return ((tot + c.charCodeAt(0)) * 17) % 256;
  }, 0);
};

const boxes = Array.from({ length: 256 }, () => []);

input.forEach((l) => {
  const [label, focalLength] = l.endsWith("-") ? l.split("-") : l.split("=");

  const hash = HASH(label);

  if (!!focalLength) {
    const index = boxes[hash].findIndex(([blabel, _]) => label === blabel);

    if (index !== -1) {
      boxes[hash][index] = [label, focalLength];
    } else {
      boxes[hash].push([label, focalLength]);
    }
  } else {
    boxes[hash] = boxes[hash].filter(([blabel, _]) => label !== blabel);
  }
});

const res = boxes.reduce((tot, box, i) => {
  return (
    tot +
    box.reduce((tott, [, focal], j) => {
      return tott + (i + 1) * (j + 1) * +focal;
    }, 0)
  );
}, 0);

console.log(res);
