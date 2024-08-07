const f = Bun.file("input");
const ff = await f.text();
const input = ff.split("\n").flatMap((l) =>
  l
    .split(":")
    .slice(1)
    .map((l) =>
      l
        .split("|")
        .map((p) => p.trim().replaceAll("  ", " ").split(" ").map(Number))
    )
);

const cardsMap = input.map(([winningNumbers, ownedNumbers], index) => {
  const wins = ownedNumbers.filter((onumber) =>
    winningNumbers.some((wnumber) => wnumber - onumber === 0)
  );

  const winsAmount = wins.length;

  return Array(winsAmount)
    .fill("")
    .map((_, i) => index + i + 2);
});

const cards = cardsMap.reduce((res, map, i) => {
  map.forEach((l) => {
    res[l - 1] = res[l - 1] + res[i];
  });

  return res;
}, Array(input.length).fill(1));

const res = cards.reduce((tot, amt) => tot + amt, 0);

console.log(res);

// const cards = input.reduce((wcards, [winningNumbers, ownedNumbers], index) => {
//   const wins = ownedNumbers.filter((onumber) =>
//     winningNumbers.some((wnumber) => wnumber - onumber === 0)
//   );

//   const winsAmount = wins.length;

//   console.log([
//     ...Array(winsAmount)
//       .fill("")
//       .map((_, i) => index + i + 2),
//   ]);

//   return [
//     ...wcards,
//     ...Array(winsAmount)
//       .fill("")
//       .map((_, i) => input[index + i + 1]),
//   ];
// }, []);

// console.log(cards);
