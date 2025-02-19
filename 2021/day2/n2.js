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
  forward: ([depth, hor, aim], v) => [depth + aim * v, hor + v, aim],
  up: ([depth, hor, aim], v) => [depth, hor, aim - v],
  down: ([depth, hor, aim], v) => [depth, hor, aim + v],
};

const getNewPosition = (position, instruction) => {
  const [instructionType, length] = instruction;
  return instructions[instructionType](position, length);
};

const position = input.reduce(getNewPosition, [0, 0, 0]);

console.log(position[0] * position[1]);
