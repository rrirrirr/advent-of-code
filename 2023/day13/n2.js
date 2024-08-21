const f = Bun.file("input");
const t = await f.text();
const input = t
  .trim()
  .split("\n\n")
  .map((l) => l.split("\n"));

const getDifference = (a, b) => {
  return a.split("").reduce((tot, c, i) => {
    return tot + +(c !== b.at(i));
  }, 0);
};

const makeAlternatives = (grid) => {
  return grid.reduce((acc, r, i) => {
    const alts = Array.from({ length: grid.length }, (_, i) => i)
      .filter((_, j) => j !== i)
      .map((index) => [index, getDifference(r, grid[index])])
      .filter(([_, d]) => d === 1)
      .map(([index]) => grid.toSpliced(index, 1, r));

    return [...acc, ...alts];
  }, []);
};

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

const initialHMirrors = input
  .map(lookForHorizontalReflection)
  .map((n) => n[0]?.toString() || "-1,-1");

const initialVMirrors = input
  .map(lookForVerticalReflection)
  .map((n) => n[0]?.toString() || "-1,-1");

const h = input
  .map((g) =>
    makeAlternatives(g)
      .flatMap(lookForHorizontalReflection)
      .reduce((acc, n) => {
        return acc.includes(n.toString()) ? acc : [...acc, n.toString()];
      }, [])
  )
  .map((starts, i) =>
    starts.filter((n) => {
      return n !== initialHMirrors[i];
    })
  );

const v = input
  .map((g) =>
    makeAlternatives(transposeGrid(g))
      .flatMap(lookForHorizontalReflection)
      .reduce((acc, n) => {
        return acc.includes(n.toString()) ? acc : [...acc, n.toString()];
      }, [])
  )
  .map((starts, i) =>
    starts.filter((n) => {
      return n !== initialVMirrors[i];
    })
  );

const res = h.reduce((tot, n, i) => {
  const hv = n.length ? +n[0].split(",").at(1) * 100 : 0;
  const vv = v[i].length ? +v[i][0].split(",").at(1) : 0;

  return tot + hv + vv;
}, 0);

console.log(res);
