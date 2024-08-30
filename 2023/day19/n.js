const input = await Bun.file("input")
  .text()
  .then((v) => v.split("\n\n"));

const p1 = input[0].split("\n");
const parts = input[1]
  .split("\n")
  .slice(0, -1)
  .map((str) =>
    str
      .replace(/[\{\}]/g, "")
      .split(",")
      .map((str) => {
        const [a, b] = str.split("=");
        return [a, Number(b)];
      })
  )
  .map((l) => Object.fromEntries(l));

const workFlows = {
  A: [() => true],
  R: [() => false],
};

const compare = (operator) => (a, b) => {
  if (operator === ">") return a > b;
  if (operator === "<") return a < b;

  return true;
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
          if (compare(operator)(values[whatToCompare], numberToCompare)) {
            return workFlows[to];
          }
          return "continue";
        };
      } else {
        return (_) => {
          return workFlows[rule];
        };
      }
    });
  workFlows[name] = newRules;
  return newRules;
});

const res = parts
  .map((part) => {
    let rules = workFlows.in;

    let i = 0;
    while (rules?.length) {
      const newRules = rules[i](part);
      if (newRules !== "continue") {
        i = 0;
        rules = newRules;
      } else {
        i++;
      }
    }

    return rules ? part.s + part.m + part.a + part.x : 0;
  })
  .reduce((tot, n) => tot + n);

console.log(res);
