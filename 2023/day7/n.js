const f = Bun.file("./input");
const t = await f.text();

const input = t
  .split("\n")
  .map((l) => l.split(" "))
  .map(([hand, score]) => [hand, +score])
  .slice(0, -1);

const translation = {
  A: 14,
  K: 13,
  Q: 12,
  J: 11,
  T: 10,
  9: 9,
  8: 8,
  7: 7,
  6: 6,
  5: 5,
  4: 4,
  3: 3,
  2: 2,
};

const possibleHands = {
  5: 1,
  41: 2,
  32: 3,
  311: 4,
  221: 5,
  2111: 6,
  11111: 7,
};

const giveNumber = (c) => translation[c];

const scoreHand = ([s, score]) => {
  const updatedHand = s.split("").reduce((hand, card) => {
    hand[card]++;
    return hand;
  }, Object.fromEntries(s.split("").map((c) => [c, 0])));

  const id = Object.values(updatedHand).sort().reverse().join("");
  const rank = possibleHands[id];

  const sortedHand = Object.entries(updatedHand).sort(
    ([symbolA, amountA], [symbolB, amountB]) => {
      return amountB === amountA
        ? giveNumber(symbolB) > giveNumber(symbolA)
        : amountB > amountA;
    }
  );

  return [rank, sortedHand, score];
};

const hasHighestCard = (h1, h2) => {
  for (let i = 0; i < h1.length; i++) {
    const value1 = giveNumber(h1[i][0]);
    const value2 = giveNumber(h2[i][0]);

    if (value1 !== value2) {
      return value1 > value2;
    }
  }

  return false;
};

const res = input.map(scoreHand);

const sorted = res.sort(([rankA, handA, _], [rankB, handB, __]) => {
  if (rankA === rankB) {
    return hasHighestCard(handA, handB);
  }
  return rankB - rankA;
});

const score = sorted.reduce((acc, [_, __, n], i) => (i + 1) * n + acc, 0);

console.log(score);
// console.log(sorted.map(([_, h, __]) => h.map(([f, l]) => f).join("")));
