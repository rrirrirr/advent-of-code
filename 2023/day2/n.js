const f = Bun.file("input");

const input = await f.text();

const colorPositions = { red: 0, green: 1, blue: 2 };
const games = input
  .split("\n")
  .slice(0, -1)
  .map((game) => game.split(":")[1]);

const maxCubes = games.reduce((acc, curr) => {
  const split = curr.split(";");
  return [
    ...acc,
    split.reduce(
      (acc, curr) => {
        const colors = curr.split(",");
        const max = acc;
        colors.forEach((color) => {
          const split = color.split(" ");
          max[split[2]] = Math.max(max[split[2]], +split[1]);
        });
        return max;
      },
      { red: 0, blue: 0, green: 0 }
    ),
  ];
}, []);

// First puzzle
// const sum = maxCubes.reduce((sum, maxCubesInGame, index) => {
//   const redPass = maxCubesInGame.red <= 12;
//   const greenPass = maxCubesInGame.green <= 13;
//   const bluePass = maxCubesInGame.blue <= 14;

//   return sum + (redPass && greenPass && bluePass ? index + 1 : 0);
// }, 0);

const sum = maxCubes.reduce((sum, game) => {
  return sum + game.red * game.green * game.blue;
}, 0);

console.log(sum);
