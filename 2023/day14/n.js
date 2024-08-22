const input = await Bun.file("input")
  .text()
  .then((v) =>
    v.split("\n\n").map((n) => {
      const split = n.split("\n");
      return Array.from({ length: split[0].length }, (c, i) => {
        return [
          ...Array.from({ length: split.length - 1 }, (r, j) => {
            return split[j].at(i);
          }),
        ];
      });
    })
  );

const moveOs = (col) => {
  if (!col.length) return [];
  const firstHash = col.findIndex((c) => c === "#");
  const end = firstHash >= 0 ? Math.max(1, firstHash) : col.length;
  const part = col.slice(0, end);
  const rest = col.slice(end);

  const os = part.filter((c) => c === "O").length;
  const dots = part.filter((c) => c === ".").length;
  const hash = part.filter((c) => c === "#").length;

  return [
    ...Array(os).fill("O"),
    ...Array(dots).fill("."),
    ...Array(hash).fill("#"),
    ...moveOs(rest),
  ];
};

const res = input.map((grid) => {
  const length = grid[0].length;
  return grid
    .map(moveOs)
    .map((col) =>
      col
        .map((c, i) => (c === "O" ? length - i : c))
        .filter(Number)
        .reduce((tot, n) => tot + n, 0)
    )
    .reduce((tot, n) => tot + n, 0);
});

console.log(res);
