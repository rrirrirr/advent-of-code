const input = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .filter(Boolean)
      .map((row) =>
        row.split(":").map((part) => part.split(" ").filter(Boolean)),
      ),
  );

const createGraph = (input) => {
  return input.reduce(
    ({ components, connections, componentMap }, [[from], to]) => {
      const newComponents = [from, ...to].filter(
        (t) => !components.includes(t),
      );
      const newConnections = to.map((c) => [c, from]);
      to.forEach((t) => {
        if (!(from in componentMap)) componentMap[from] = new Set();
        if (!(t in componentMap)) componentMap[t] = new Set();
        componentMap[from].add(t);
        componentMap[t].add(from);
      });
      return {
        components: [...newComponents, ...components],
        connections: [...newConnections, ...connections],
        componentMap,
      };
    },
    {
      components: [],
      connections: [],
      componentMap: {},
    },
  );
};

const karger = (components, connections) => {
  let subsets = components.map((c) => [c]);

  while (subsets.length > 2) {
    const randomIndex = Math.floor(Math.random() * connections.length);
    const [v1, v2] = connections[randomIndex];

    const subset1 = subsets.find((s) => s.includes(v1));
    const subset2 = subsets.find((s) => s.includes(v2));

    if (subset1 !== subset2) {
      subsets = subsets.filter((s) => s !== subset2);
      subset1.push(...subset2);
    }

    connections.splice(randomIndex, 1);
  }

  return subsets;
};

const countCuts = (subsets, components, componentMap) => {
  let cuts = 0;
  components.forEach((v) => {
    const subset = subsets.find((s) => s.includes(v));
    componentMap[v].forEach((neighbor) => {
      if (!subset.includes(neighbor)) {
        cuts++;
      }
    });
  });
  return cuts / 2;
};

const run = () => {
  const { components, connections, componentMap } = createGraph(input);
  let subsets;
  let cuts = 0;
  let attempts = 0;
  while (cuts !== 3) {
    attempts++;
    subsets = karger(components, [...connections]);
    cuts = countCuts(subsets, components, componentMap);
    console.log(`Attempt ${attempts}: cuts ${cuts}`);
  }

  const result = subsets[0].length * subsets[1].length;
  console.log(result);
};

run();
