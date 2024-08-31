const input = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .slice(0, -1)
      .map((str) => str.split(" -> ").map((str) => str.split(", "))),
  );

const modules = {
  rx: {
    recentPulses: { jq: -1 },
    propagate: (signal) => {
      sent[signal + 1]++;
    },
  },
};

const q = [];
const sent = [0, 0, 0];
const conjunctions = [];

input.forEach(([[moduleName], output]) => {
  if (moduleName.startsWith("broadcaster")) {
    modules.broadcaster = {
      propagate: (i) => {
        sent[0]++;
        output.forEach((key) => {
          q.push(() => modules[key].propagate(-1, "broadcaster", i));
        });
      },
    };
  } else if (moduleName.startsWith("%")) {
    const name = moduleName.slice(1);
    modules[name] = {
      on: false,
      propagate: (signal, from, i) => {
        sent[signal + 1]++;
        if (signal === 1) return;
        modules[name].on = !modules[name].on;
        const flip = modules[name].on ? 1 : -1;
        output.forEach((key) => {
          q.push(() => modules[key].propagate(flip, name, i));
        });
      },
    };
  } else if (moduleName.startsWith("&")) {
    const name = moduleName.slice(1);
    conjunctions.push(name);
    modules[name] = {
      recentPulses: {},
      firstTriggered: 0,
      propagate: (signal, from, i) => {
        sent[signal + 1]++;
        modules[name].recentPulses[from] = signal;
        const newSignal = Object.values(modules[name].recentPulses).every(
          (signal) => signal === 1,
        )
          ? -1
          : 1;
        if (newSignal === 1 && modules[name].firstTriggered === 0) {
          modules[name].firstTriggered = i + 1;
        }
        output.forEach((key) => {
          if (modules[key]) {
            q.push(() => modules[key].propagate(newSignal, name, i));
          } else {
            console.log("Module not found:", key);
          }
        });
      },
    };
  }
});

conjunctions.forEach((conj) => {
  input.forEach(([[from], to]) => {
    if (to.includes(conj)) {
      modules[conj].recentPulses[from.slice(1)] = -1;
    }
  });
});

const findParents = (name, level = 0) => {
  return input
    .filter(([[from], to]) => to.includes(name))
    .map(([[from]]) =>
      level < 1 ? findParents(from.slice(1), level + 1) : from.slice(1),
    )
    .flat();
};

const parents = findParents("rx");

const gcd = (a, b) => (!b ? a : gcd(b, a % b));
const lcm = (a, b) => (a * b) / gcd(a, b);
const lcmOfList = (numbers) => numbers.reduce(lcm);

let i = 0;
while (parents.some((parent) => modules[parent].firstTriggered === 0)) {
  q.push(() => modules.broadcaster.propagate(i));
  while (q.length) {
    q.shift()();
  }
  i++;
}

const result = lcmOfList(
  parents.map((parent) => modules[parent].firstTriggered),
);
console.log(result);
