const input = await Bun.file("input")
  .text()
  .then((v) =>
    v
      .split("\n")
      .slice(0, -1)
      .map((str) => str.split(" -> ").map((str) => str.split(", "))),
  );

const sortedInput = input.sort(([[aname], _], [[bname], __]) => {
  if (aname.startsWith("&") && !bname.startsWith("&")) return -1;
  if (!aname.startsWith("&") && bname.startsWith("&")) return 1;
  return 0;
});

const modules = {
  rx: {
    propagate: (signal, from) => {
      sent[signal + 1]++;
      // console.log(from, `(${signal === 1 ? "high" : "low"}) =>`, "output");
    },
  },
};

const q = [];

const sent = [0, 0, 0];

sortedInput.forEach(([[moduleName], output]) => {
  if (moduleName.startsWith("broadcaster")) {
    modules.broadcaster = {
      propagate: () => {
        // console.log("button (low) => broadcaster");
        sent[0]++;

        output.forEach((key) => {
          q.push(() => modules[key].propagate(-1, "broadcaster"));
        });
      },
    };
  }

  if (moduleName.startsWith("%")) {
    const name = moduleName.slice(1);
    output.forEach((key) => {
      if (modules[key] && "recentPulses" in modules[key]) {
        modules[key].recentPulses[name] = -1;
      }
    });

    modules[name] = {
      on: false,
      propagate: (signal, from) => {
        // console.log(from, `(${signal === 1 ? "high" : "low"}) =>`, name);
        sent[signal + 1]++;

        // stop if pulse is high
        if (signal === 1) return;

        modules[name].on = !modules[name].on;

        const flip = modules[name].on ? -1 : 1;

        output.forEach((key) => {
          q.push(() => modules[key].propagate(signal * flip, name));
        });
      },
    };
  }

  if (moduleName.startsWith("&")) {
    const name = moduleName.slice(1);
    modules[name] = {
      recentPulses: {},
      propagate: (signal, from) => {
        // console.log(from, `(${signal === 1 ? "high" : "low"}) =>`, name);
        sent[signal + 1]++;

        modules[name].recentPulses[from] = signal;

        // send low signal if memory for all connections latest pulse was highotherwise send highpulse
        const newSignal = Object.values(modules[name].recentPulses).every(
          (signal) => signal === 1,
        )
          ? -1
          : 1;

        output.forEach((key) => {
          if (modules[key]) {
            q.push(() => modules[key].propagate(newSignal, name));
          } else {
            console.log("not found", key);
          }
        });
      },
    };
  }
});

for (let i = 0; i < 1000; i++) {
  // console.log("\n", `push #${i + 1}`, "\n");
  q.push(() => modules.broadcaster.propagate());

  while (q.length) {
    const n = q.shift();
    n();
  }
}

console.log(`low: ${sent[0]}, high: ${sent[2]}`);
console.log(sent[0] * sent[2]);
