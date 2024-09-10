const input = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .slice(0, -1)
      .map((v) => v.split("").map(Number)),
  );

const getMostCommonBit = (numbers, position, criteria) => {
  const sum = numbers.reduce((total, number) => total + number[position], 0);
  const mostCommon = sum >= numbers.length / 2 ? 1 : 0;
  return criteria === "oxygen" ? mostCommon : 1 - mostCommon;
};

const binaryArrayToDecimal = (binaryArray) => {
  return binaryArray.reduce(
    (total, bit, index) => total + bit * 2 ** (binaryArray.length - 1 - index),
    0,
  );
};

const filterByCriteria = (criteria) => (numbers) => {
  return numbers
    .reduce(
      (left, _, i) => {
        if (left.length === 1) return left;
        const v = getMostCommonBit(left, i, criteria);
        return left.filter((l) => l[i] === v);
      },
      [...input],
    )
    .flat();
};

const reverse = (arr) => arr.reverse();

const oxygen = [filterByCriteria("oxygen"), binaryArrayToDecimal].reduce(
  (acc, fn) => {
    return fn(acc);
  },
  input,
);

const co2 = [filterByCriteria("co2"), binaryArrayToDecimal].reduce(
  (acc, fn) => {
    return fn(acc);
  },
  input,
);

console.log(co2 * oxygen);
