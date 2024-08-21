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

const transposeGrid = (grid) => {
  return grid[0]
    .split("")
    .map((_, colIndex) => grid.map((row) => row[colIndex]).join(""))
    .filter(Boolean);
};

const lookForHorizontalReflection = (grid) => {
  const map = mapHorizontal(grid);

  const startingPoints = Object.entries(map)
    .filter(([_, nums]) => nums.length > 1)
    .flatMap(([_, nums]) => {
      return nums
        .reduce((acc, num, i) => {
          return num + 1 === nums[i + 1] ? [...acc, [num, nums[i + 1]]] : acc;
        }, [])
        .filter((a) => a.length);
    });

  const mirrored = startingPoints.filter(([a, b]) => {
    let up = a;
    let down = b;

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
  const transposed = transposeGrid(grid);
  const map = mapHorizontal(transposed);

  const startingPoints = Object.entries(map)
    .filter(([_, nums]) => nums.length > 1)
    .flatMap(([_, nums]) => {
      return nums
        .reduce((acc, num, i) => {
          return num + 1 === nums[i + 1] ? [...acc, [num, nums[i + 1]]] : acc;
        }, [])
        .filter((a) => a.length);
    });

  const mirrored = startingPoints.filter(([a, b]) => {
    let left = a;
    let right = b;

    while (left >= 0 && right < transposed.length) {
      if (transposed[left] !== transposed[right]) {
        return false;
      }
      left--;
      right++;
    }

    return true;
  });

  return mirrored;
};

const res =
  input
    .flatMap(lookForHorizontalReflection)
    .reduce((acc, [__, n, _]) => acc + n * 100, 0) +
  input.flatMap(lookForVerticalReflection).reduce((acc, [_, n]) => {
    return acc + n;
  }, 0);

console.log(res);
