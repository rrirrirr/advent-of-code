const time = [40817772];
const record = [219101213651089];

// const time = [7, 15, 30];
// const record = [9, 40, 200];

const findWins = (k) => {
  const t = time[k];
  return Array(t + 1)
    .fill(0)
    .reduce((acc, _, i) => {
      const dist = i * (t - i);
      return dist > record[k] ? [...acc, i] : acc;
    }, []).length;
};

const prod = (acc, f) => {
  return acc * f;
};

const res = time
  .map((_, i) => {
    return findWins(i);
  })
  .reduce(prod, 1);

console.log(res);
