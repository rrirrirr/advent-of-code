const input = await Bun.file("input")
  .text()
  .then((v) => v.split("\n\n"));

const p1 = input[0].split("\n");
const parts = {
  x: [1, 4000],
  m: [1, 4000],
  a: [1, 4000],
  s: [1, 4000],
};

const workFlows = {
  A: [(values) => ({ newParts: values, rules: [] })],
  R: [(_) => ({ newParts: false, rules: [] })],
};

const setBoundary = (operator) => (v, numberToCompare) => {
  if (operator === ">")
    return [
      [numberToCompare + 1, v[1]],
      [v[0], numberToCompare],
    ];
  if (operator === "<")
    return [
      [v[0], numberToCompare - 1],
      [numberToCompare, v[1]],
    ];
};

const rules = p1.map((l) => {
  const [name, r] = l.split("{");
  const newRules = r
    .slice(0, -1)
    .split(",")
    .map((rule) => {
      if (rule.includes(":")) {
        const [comparison, to] = rule.split(":");
        const whatToCompare = comparison.slice(0, 1);

        const operator = comparison.slice(1, 2);

        const numberToCompare = Number(comparison.slice(2));

        return (values) => {
          // console.log(rule);

          const newBoundaries = setBoundary(operator)(
            values[whatToCompare],
            numberToCompare,
          );

          const remainingParts = Object.assign({}, values);
          const newParts = Object.assign({}, values);

          newParts[whatToCompare] = newBoundaries[0];
          remainingParts[whatToCompare] = newBoundaries[1];

          return { newParts, remainingParts, rules: workFlows[to] };
        };
      } else {
        return (values) => {
          // console.log(rule);
          return { newParts: values, rules: workFlows[rule] };
        };
      }
    });

  workFlows[name] = newRules;

  return newRules;
});

const res = [];

const calc = (startingRules, parts) => {
  let currentParts = parts;
  let currentRules = startingRules;
  let i = 0;

  while (currentRules?.length) {
    if (!currentParts) return false;

    const newRules = currentRules[i](currentParts);

    if ("remainingParts" in newRules) {
      currentParts = newRules.remainingParts;
      calc(newRules.rules, newRules.newParts);
      i++;
    } else {
      currentParts = newRules.newParts;
      currentRules = newRules.rules;
      i = 0;
    }
  }

  res.push(currentParts);
};

calc(workFlows.in, parts);

const boundaries = res.filter(Boolean);

const calculateWinningCombinations = (boundaries) => {
  return boundaries.reduce((tot, boundary) => {
    const combinations = Object.values(boundary).reduce(
      (product, [min, max]) => {
        return product * (max - min + 1);
      },
      1,
    );
    return tot + combinations;
  }, 0);
};

const totalWinningCombinations = calculateWinningCombinations(boundaries);

console.log(totalWinningCombinations);
