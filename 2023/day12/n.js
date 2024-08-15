const f = Bun.file("./input");
const t = await f.text();

const groupSprings = (springRow) => {
  return springRow
    .split(/(?=\.)|(?<=\.)/)
    .filter(Boolean)
    .filter((g) => g !== ".");
};

const input = t
  .split("\n")
  .slice(0, -1)
  .map((l) => {
    const [a, b] = l.split(" ");
    return (
      (a + "?").repeat(5).slice(0, -1) +
      " " +
      (b + ",").repeat(5).slice(0, -1)
    ).split(" ");
  })
  .map(([groups, pattern]) => [
    groupSprings(groups),
    pattern.split(",").map(Number),
  ]);

const hashesLeft = (groups) => {
  return groups.some((str) => str.includes("#"));
};

const fillCache = new Map();

// return array after removing length chars in all possible combinations
const fillGroup = (group, length) => {
  const cacheKey = group + length;
  if (fillCache.has(cacheKey)) return fillCache.get(cacheKey);

  if (group.length < length) return [];

  const results = [];

  for (let i = group.length - 1; i >= length - 1; i--) {
    const before = group.slice(0, i - length + 1);

    if (group[i] === "#") {
      if (before.at(-1) !== "#") results.push(before.slice(0, -1));
      break; // must exit for loop when first # is found
    }

    if (before.at(-1) !== "#") results.push(before.slice(0, -1));
  }

  fillCache.set(cacheKey, results);
  return results;
};

const patternCache = new Map();

const findPattern = (groups, pattern) => {
  if (pattern.length === 0) {
    return hashesLeft(groups) ? 0 : 1;
  }
  if (groups.length === 0) return 0;

  const key = groups.join(",") + " " + pattern;
  if (patternCache.has(key)) return patternCache.get(key);

  const currGroup = groups.at(-1);
  const currPattern = pattern.at(-1);

  const rest = fillGroup(currGroup, currPattern);

  const remainingCombinations = rest.reduce((acc, remainderGroup, i) => {
    const updatedGroups = [...groups.slice(0, -1), remainderGroup].filter(
      (g) => g.length > 0
    );
    return acc + findPattern(updatedGroups, pattern.slice(0, -1));
  }, 0);

  const skipCurrentGroup = currGroup.includes("#")
    ? 0
    : findPattern([...groups.slice(0, -1)], pattern);

  const result = remainingCombinations + skipCurrentGroup;

  patternCache.set(key, result);
  return result;
};

const res = input.reduce((acc, [springs, pattern], i) => {
  const solutions = findPattern(springs, pattern);
  return acc + solutions;
}, 0);

console.log(res);
