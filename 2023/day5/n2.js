const f = Bun.file("input");
const text = await f.text(f);

const lines = text.split("\n\n").map((l) =>
  l
    .split(":")[1]
    .trim()
    .split("\n")
    .map((m) => m.split(" ").map(Number))
);

const [sr, ...rest] = lines;

const seedsRanges = sr[0];

const seeds = Array(seedsRanges.length / 2)
  .fill("")
  .reduce((seeds, _, i) => {
    const [from, length] = seedsRanges.slice(i * 2, i * 2 + 2);

    return [...seeds, [from, from + length - 1]];
  }, []);

const applyMapping = (ranges, mapSet) => {
  const mappedRanges = [];

  const unchangedMappings = mapSet.reduce(
    (newRanges, [dest, source, length]) => {
      const shift = dest - source;
      const sourceEnd = source + length - 1;
      const destEnd = dest + length - 1;

      const notMappedRanges = newRanges.reduce((acc, [from, to]) => {
        if (from > to) return acc;

        // Completely within source range
        if (from >= source && to <= sourceEnd) {
          mappedRanges.push([from + shift, to + shift]);
        }
        // Overlapping at the start
        else if (from < source && to >= source && to <= sourceEnd) {
          mappedRanges.push([source + shift, to + shift]);
          acc.push([from, source - 1]);
        }
        // Overlapping at the end
        else if (from >= source && from <= sourceEnd && to > sourceEnd) {
          mappedRanges.push([from + shift, destEnd]);
          acc.push([sourceEnd + 1, to]);
        }
        // Enclosing the source range
        else if (from < source && to > sourceEnd) {
          mappedRanges.push([source + shift, destEnd]);
          acc.push([from, source - 1], [sourceEnd + 1, to]);
        } else {
          acc.push([from, to]);
        }

        return acc;
      }, []);

      return notMappedRanges;
    },
    ranges
  );

  return [...unchangedMappings, ...mappedRanges];
};

const res = rest.reduce(applyMapping, seeds);

const lowest = res.reduce((min, curr) => Math.min(min, curr[0]), Infinity);

console.log(lowest);
