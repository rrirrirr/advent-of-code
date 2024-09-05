const input = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .slice(0, -1)
      .map((l) => {
        const [instruction, length] = l.split(" ");
        return [instruction, +length];
      }),
  );

const instructions = {
  forward: ([depth, hor], v) => [depth, hor + v],
  up: ([depth, hor], v) => [depth - v, hor],
  down: ([depth, hor], v) => [depth + v, hor],
};

const position = input.reduce(
  (pos, instruction) => {
    const [instructionType, length] = instruction;
    return instructions[instructionType](pos, length);
  },
  [0, 0],
);

console.log(position[0] * position[1]);
