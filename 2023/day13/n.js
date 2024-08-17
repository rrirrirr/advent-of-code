const f = Bun.file("input");
const t = await f.text();
const input = t
  .trim()
  .split("\n\n")
  .map((l) => l.split("\n"));

const mapHorizontal = (grid) => {
  return grid.reduce((acc, r, i) => {
    acc[r].push(i);
    return acc;
  }, Object.fromEntries(grid.map((r) => [r, []])));
};

const mapVertical = (grid) => {
  const transposedGrid = grid.map((_, colIndex) =>
    grid.map((row) => row[colIndex]).join("")
  );

  return transposedGrid.reduce((acc, c, i) => {
    if (!acc[c]) {
      acc[c] = [];
    }
    acc[c].push(i);
    return acc;
  }, {});
};

const lookForHorizontalReflection = (grid) => {
  const map = mapHorizontal(grid);

  const startingPoints = Object.entries(map)
    .filter(([_, nums]) => nums.length > 1)
    .map(([_, nums]) => {
      return nums;
    })
    .filter(([anum, bnum], i) => {
      return anum + 1 === bnum;
    });

  const mirrored = startingPoints.filter(([a, b]) => {
    let up = a - 1;
    let down = b + 1;

    while (up >= 0 && down < grid.length) {
      if (grid[up] !== grid[down]) {
        return false;
      }
      up--;
      down++;
    }

    return true;
  });

  return mirrored;
};

const lookForVerticalReflection = (grid) => {
  const map = mapVertical(grid);

  const startingPoints = Object.entries(map)
    .filter(([_, nums]) => nums.length > 1)
    .map(([_, nums]) => {
      return nums;
    })
    .filter(([anum, bnum], i) => {
      return anum + 1 === bnum;
    });

  const mirrored = startingPoints.filter(([a, b]) => {
    let left = a - 1;
    let right = b + 1;

    while (left >= 0 && right < grid[0].length) {
      for (let row = 0; row < grid.length; row++) {
        if (grid[row][left] !== grid[row][right]) {
          return false;
        }
      }
      left--;
      right++;
    }

    return true;
  });

  return mirrored;
};

console.log("horizontal:", lookForHorizontalReflection(input[0]));
console.log("vertical:", lookForVerticalReflection(input[0]));

// const res =
// input
//   .flatMap(lookForHorizontalReflection)
//   .reduce((acc, [n, _]) => (n + 1) * 100, 0) +
// input
//   .flatMap(lookForVerticalReflection)
//   .reduce((acc, [n, _]) => (n + 1) * 1, 0);

// console.log(res);
