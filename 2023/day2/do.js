const input = [
  "1: 18 red, 8 green, 7 blue; 15 red, 4 blue, 1 green; 2 green, 17 red, 6 blue; 5 green, 1 blue, 11 red; 18 red, 1 green, 14 blue; 8 blue",
  "2: 16 blue, 12 green, 3 red; 13 blue, 2 red, 8 green; 15 green, 3 red, 16 blue",
  "3: 6 green, 15 red; 1 green, 4 red, 7 blue; 9 blue, 7 red, 8 green",
  "4: 8 red, 2 blue; 11 red, 5 blue, 1 green; 12 red, 1 green, 5 blue; 1 blue; 2 blue, 9 red",
  "5: 9 blue, 3 red, 12 green; 3 green, 4 red, 17 blue; 15 blue, 2 green, 5 red; 3 blue, 5 green, 6 red; 6 red, 4 blue, 7 green; 3 green, 10 blue",
  "6: 11 red, 2 blue, 6 green; 2 blue, 9 red, 4 green; 3 blue, 12 red, 8 green; 5 red, 11 green, 4 blue; 2 blue, 9 red, 13 green; 15 red, 3 blue, 7 green",
  "7: 2 red, 9 green, 12 blue; 14 blue, 1 green, 6 red; 7 blue, 9 green; 9 green, 8 red, 4 blue; 5 red, 3 green, 16 blue; 4 red, 8 green",
  "8: 11 red, 12 green, 1 blue; 4 red, 7 green; 11 red, 6 green; 17 green; 15 green, 1 red",
  "9: 1 red, 1 green, 12 blue; 3 green, 12 red, 6 blue; 14 red, 1 blue; 9 blue, 1 red, 3 green",
  "10: 1 red, 4 blue; 3 blue, 4 green; 3 green, 3 red, 8 blue; 2 blue, 3 red; 3 green, 4 red, 3 blue",
  "11: 8 blue, 1 red; 8 green, 1 red, 1 blue; 13 green, 9 red, 6 blue",
  "12: 2 red, 2 blue, 1 green; 3 red, 1 green; 1 blue, 3 green",
  "13: 12 green, 4 blue; 2 red, 2 blue, 8 green; 6 green, 3 red; 3 red, 5 green; 9 green, 7 blue, 1 red",
  "14: 1 red, 7 green; 5 green, 12 red, 10 blue; 9 red, 11 blue, 7 green; 7 blue, 3 red, 9 green",
  "15: 7 green, 1 blue; 1 red, 2 green, 1 blue; 7 green",
  "16: 1 green, 1 blue; 2 blue, 4 green, 2 red; 2 green, 2 blue",
  "17: 6 red, 11 green, 7 blue; 1 blue, 13 green, 4 red; 4 green, 6 blue, 7 red",
  "18: 2 red, 8 blue; 7 red, 11 blue; 1 green, 16 blue, 7 red; 18 blue, 1 green, 14 red",
  "19: 2 red, 2 blue; 1 green, 6 red; 1 green, 3 red, 2 blue",
  "20: 6 red, 2 blue, 5 green; 4 red, 1 blue, 9 green; 3 blue, 2 red, 9 green; 8 red, 12 green, 5 blue",
  "21: 6 red, 7 blue; 3 blue, 16 red, 2 green; 2 blue, 13 red; 3 blue, 11 red, 3 green; 1 green, 18 red, 6 blue; 12 red, 5 blue, 2 green",
  "22: 9 red, 6 blue, 14 green; 1 blue, 5 green, 13 red; 6 red; 18 red, 4 green; 2 blue, 10 green, 16 red; 1 red, 18 green, 1 blue",
  "23: 6 green, 4 red, 3 blue; 1 blue, 2 red, 9 green; 5 green, 1 red, 3 blue; 5 blue, 4 red, 4 green",
  "24: 1 red, 5 green, 2 blue; 4 red, 7 green, 9 blue; 9 blue, 7 green; 7 green, 13 blue; 4 blue, 1 green, 4 red",
  "25: 13 blue, 10 red, 11 green; 10 green, 1 blue, 3 red; 15 red, 5 green, 8 blue; 19 red, 10 green, 13 blue; 12 blue, 4 green, 16 red; 7 red, 5 green, 9 blue",
  "26: 20 red, 6 blue, 12 green; 15 blue, 17 red, 9 green; 19 red, 6 green, 3 blue; 8 green, 1 red, 15 blue; 10 green, 8 red, 5 blue; 4 green, 20 red, 18 blue",
  "27: 2 blue, 3 green, 7 red; 2 blue, 4 red; 5 blue, 5 green; 8 blue, 6 green, 2 red",
  "28: 1 green, 6 red; 3 red, 3 blue; 1 green, 4 red; 1 red, 2 blue; 2 red",
  "29: 8 blue, 1 green; 7 blue, 1 red; 6 red, 2 blue; 2 red, 3 green; 3 red, 6 green, 5 blue",
  "30: 11 blue, 17 green, 10 red; 9 blue, 12 green, 14 red; 16 green, 2 red, 8 blue; 18 green, 1 red, 1 blue; 5 blue, 7 red, 18 green; 9 green, 3 blue, 11 red",
  "31: 5 blue, 13 green; 2 green, 3 red, 4 blue; 3 red, 15 green, 2 blue; 5 blue, 19 green; 5 blue, 18 green; 3 green, 7 blue, 3 red",
  "32: 12 red, 2 green, 3 blue; 2 green, 16 red, 1 blue; 13 red, 4 green, 6 blue",
  "33: 18 green, 8 blue, 3 red; 15 green, 2 blue, 4 red; 14 blue, 3 red, 6 green; 20 green, 13 blue; 1 red, 19 green",
  "34: 1 green, 7 blue, 2 red; 8 green, 10 blue, 2 red; 3 blue, 1 green, 1 red; 6 green, 13 blue, 1 red; 1 green, 4 blue, 2 red; 1 red, 5 green, 7 blue",
  "35: 7 blue, 8 red; 2 blue, 3 red; 4 blue, 3 red; 7 red, 4 blue; 1 blue, 1 green, 3 red",
  "36: 1 red, 8 green; 1 red, 6 green; 3 green, 8 red; 1 blue, 2 red, 1 green",
  "37: 3 blue, 13 red; 2 blue, 7 red; 5 red, 1 green; 3 red, 3 blue; 1 blue, 12 red, 1 green; 14 red, 3 blue",
  "38: 7 blue, 18 red, 12 green; 11 red, 6 green, 1 blue; 9 green, 1 red; 9 green, 13 blue, 16 red",
  "39: 12 red, 3 green, 2 blue; 3 blue, 3 green, 10 red; 2 blue, 5 red; 2 blue, 1 green; 5 blue, 4 green, 7 red; 2 green, 1 red",
  "40: 1 red, 7 blue, 5 green; 1 red, 4 blue, 8 green; 3 red, 5 blue, 14 green; 10 green, 2 blue, 1 red; 11 blue, 7 green, 1 red; 14 green, 2 blue",
  "41: 8 green, 5 red, 3 blue; 5 red, 4 blue, 12 green; 10 green, 6 blue; 13 green, 7 blue; 1 red, 2 green, 15 blue",
  "42: 17 red, 1 blue, 5 green; 9 green, 16 red; 1 blue, 15 green, 2 red; 1 blue, 12 red, 12 green",
  "43: 12 green, 5 blue; 3 red, 8 blue, 10 green; 8 blue, 2 green, 1 red",
  "44: 1 green, 7 red, 2 blue; 1 blue, 10 red; 4 green, 3 blue, 19 red; 1 blue, 3 green, 1 red; 1 blue; 4 red, 2 green, 3 blue",
  "45: 16 red, 12 blue, 1 green; 13 blue, 16 red, 9 green; 7 green, 3 red, 8 blue",
  "46: 1 red, 17 green, 6 blue; 6 blue, 1 red, 3 green; 12 green, 1 blue; 4 blue, 2 green",
  "47: 2 green, 12 red, 15 blue; 9 blue, 2 green, 2 red; 3 green, 6 blue, 2 red; 11 blue, 3 green, 5 red; 6 green, 9 red, 17 blue",
  "48: 5 blue, 6 red; 7 green, 14 red, 4 blue; 2 green, 5 blue, 2 red; 11 blue, 5 red, 5 green",
  "49: 7 green, 7 blue, 4 red; 11 green, 12 blue, 2 red; 12 blue, 4 red, 9 green; 3 red, 8 blue, 17 green; 16 green, 3 red, 14 blue",
  "50: 5 green, 4 red, 10 blue; 7 green, 14 red, 5 blue; 12 red, 18 blue, 14 green",
  "51: 12 green, 3 blue; 10 green, 4 blue, 2 red; 3 green, 5 blue",
  "52: 12 green, 6 red, 7 blue; 20 green, 6 red, 18 blue; 1 green, 5 blue, 11 red; 2 green, 15 blue, 6 red",
  "53: 6 red, 2 green, 5 blue; 13 green, 1 blue, 14 red; 7 green, 1 blue; 3 green, 4 blue, 6 red; 10 red, 6 green, 4 blue",
  "54: 4 blue, 1 red; 1 red, 1 blue, 9 green; 3 red, 2 blue, 4 green; 3 green, 2 red, 5 blue; 9 blue, 2 red, 7 green",
  "55: 7 blue; 6 blue, 1 red; 4 red, 7 blue; 3 red, 3 blue, 1 green",
  "56: 2 green, 7 blue; 3 red, 10 blue; 1 green, 2 red; 3 red, 8 blue, 4 green; 1 green, 11 blue, 3 red; 2 green, 8 blue",
  "57: 3 red, 1 green; 1 green, 1 red, 1 blue; 1 red, 4 green, 15 blue; 9 blue, 2 red, 1 green",
  "58: 12 blue, 13 red, 5 green; 2 blue, 6 green; 12 red, 15 green, 7 blue; 5 red, 4 green, 14 blue; 15 red, 2 green, 9 blue",
  "59: 5 green, 5 blue; 4 red, 6 blue, 2 green; 5 blue, 3 green, 6 red; 3 red, 6 green, 4 blue; 3 blue, 7 green, 10 red",
  "60: 1 red, 1 blue, 3 green; 1 red; 3 green, 6 blue; 6 blue",
  "61: 7 green, 1 red, 1 blue; 4 red, 3 green, 1 blue; 7 blue, 7 green; 11 blue, 2 green, 5 red; 5 red, 4 green, 5 blue",
  "62: 17 green, 2 red, 3 blue; 1 red, 3 blue, 2 green; 1 green, 3 blue, 2 red; 1 red, 17 green; 2 red, 15 green, 4 blue; 5 green",
  "63: 2 green, 4 red, 3 blue; 9 blue, 10 red; 1 green, 13 blue, 2 red; 2 green, 1 blue, 5 red",
  "64: 6 red, 8 blue; 3 red, 6 blue, 5 green; 13 red, 11 blue, 8 green; 11 red, 3 blue, 1 green",
  "65: 4 green, 1 blue, 2 red; 3 blue, 3 green, 11 red; 6 green, 3 blue, 3 red; 5 red, 4 blue; 8 red, 5 blue, 2 green",
  "66: 10 green, 13 red; 1 blue, 2 red, 4 green; 7 red, 7 green; 19 green, 9 red, 1 blue; 16 green, 16 red, 2 blue; 10 red, 11 green",
  "67: 3 blue, 4 green, 2 red; 6 blue, 19 red; 4 blue, 2 red, 5 green; 4 green, 5 blue, 1 red",
  "68: 13 blue, 15 red, 7 green; 5 blue, 20 red; 6 green, 12 blue, 8 red; 5 blue, 8 green",
  "69: 13 red, 13 green; 13 green, 3 red, 1 blue; 8 green; 9 green, 9 red",
  "70: 8 blue, 11 red, 2 green; 12 red, 2 blue; 13 red, 6 blue, 3 green; 7 blue, 3 green, 5 red; 15 red, 1 blue, 3 green",
  "71: 7 red, 9 green; 4 blue, 9 green, 7 red; 4 blue, 2 green; 6 blue, 2 red, 9 green",
  "72: 14 blue, 1 green; 4 red, 1 green, 9 blue; 6 blue, 8 red, 2 green",
  "73: 17 green; 10 blue, 2 red, 9 green; 1 green, 10 blue, 2 red; 8 blue, 1 red; 5 blue, 16 green",
  "74: 12 green, 6 red, 5 blue; 2 red, 4 blue, 10 green; 3 green, 4 blue, 2 red; 8 green, 2 red, 5 blue; 5 red, 2 blue, 2 green; 6 green, 1 red, 1 blue",
  "75: 4 blue, 19 green; 15 blue, 7 green; 18 blue, 5 green, 7 red; 16 green, 15 blue; 7 red, 4 green, 13 blue; 9 green, 13 blue",
  "76: 1 red, 2 green, 7 blue; 13 blue, 7 green, 1 red; 13 blue, 5 red",
  "77: 3 red, 10 blue, 6 green; 1 green, 2 red, 10 blue; 7 green, 1 red",
  "78: 11 green, 2 blue; 6 blue, 8 red, 5 green; 10 red, 6 green, 4 blue; 6 blue, 3 green, 10 red; 5 green, 6 red",
  "79: 4 red, 6 blue, 1 green; 1 red; 2 green, 3 blue, 4 red; 4 red, 1 green, 2 blue; 2 green, 1 red",
  "80: 2 red, 1 green; 1 red, 1 green; 7 red, 1 green; 1 blue, 7 red, 3 green",
  "81: 1 blue, 15 red, 4 green; 2 green, 12 red; 4 green, 13 red; 1 blue, 3 green, 13 red; 12 red, 2 green, 1 blue; 3 green, 8 red, 1 blue",
  "82: 18 red, 4 green, 1 blue; 14 red, 1 green, 2 blue; 10 red, 2 blue, 7 green; 13 red; 3 red, 7 green, 1 blue; 5 red, 4 green",
  "83: 4 red, 10 green, 5 blue; 2 red, 12 blue, 13 green; 19 blue, 9 green, 1 red; 2 red, 14 blue, 3 green; 13 green, 8 blue, 5 red",
  "84: 12 blue, 7 red, 9 green; 1 blue, 1 green, 14 red; 1 green, 8 red, 11 blue; 11 blue, 12 red, 3 green; 11 blue, 8 green, 13 red; 7 green, 7 red, 10 blue",
  "85: 10 red, 2 blue; 11 green, 9 red, 4 blue; 3 red, 5 blue, 13 green; 5 red, 5 green; 5 red, 2 blue, 4 green; 11 green, 4 blue, 19 red",
  "86: 1 blue, 6 green, 2 red; 1 red, 1 blue, 8 green; 3 red, 1 blue, 4 green; 1 green, 4 red; 9 green, 2 red; 6 green, 7 red, 1 blue",
  "87: 8 green, 8 blue, 4 red; 5 red, 2 blue, 10 green; 3 red, 13 green; 1 red, 3 blue, 4 green",
  "88: 3 blue, 9 green, 3 red; 2 blue, 15 green; 2 red, 9 green",
  "89: 9 red, 6 green, 15 blue; 10 blue, 7 red, 2 green; 7 green, 16 blue, 4 red",
  "90: 1 red, 1 blue, 7 green; 7 green, 1 blue, 8 red; 3 red, 1 blue, 1 green",
  "91: 1 green, 2 red, 6 blue; 4 green, 4 red, 3 blue; 4 red, 11 green, 4 blue; 3 blue, 5 red; 8 green, 2 red, 8 blue",
  "92: 2 red, 3 blue; 3 blue, 2 green, 2 red; 9 red, 3 green",
  "93: 2 blue, 5 green; 2 green, 5 blue, 3 red; 2 green, 5 blue, 1 red; 7 blue, 4 red, 9 green",
  "94: 1 red, 9 blue, 14 green; 6 green; 2 blue, 11 green; 4 blue, 16 green, 1 red",
  "95: 10 green, 2 blue, 7 red; 4 blue, 4 red, 6 green; 3 red, 2 blue, 3 green",
  "96: 12 red; 3 green, 10 red; 6 blue, 14 red, 2 green; 7 green, 15 red; 3 green, 3 red, 1 blue; 5 blue, 1 red",
  "97: 3 red, 1 green, 1 blue; 1 green, 3 red; 4 red, 1 green",
  "98: 4 red, 5 green, 6 blue; 2 red, 9 green, 6 blue; 2 blue, 11 red, 14 green; 6 green, 4 blue; 11 blue, 11 red, 8 green",
  "99: 2 green, 20 blue; 12 blue; 3 red, 12 blue; 7 blue; 3 green, 10 blue, 2 red; 3 red, 2 green",
  "100: 2 blue, 8 green, 12 red; 2 green, 13 red; 2 red, 4 green; 2 green, 7 red; 10 green, 5 red, 1 blue",
];

// const input = [
//   "1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
//   "2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
//   "3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
//   "4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
//   "5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
// ];

const colors = { red: 12, green: 13, blue: 14 };

const splitOnId = (line) => {
  const s = line.split(":");
  return { id: +s[0], rest: s[1].trim() };
};

const transform = (line) => {
  const r = line.rest.replaceAll(";", " ").replaceAll(",", " ");
  const r2 = r.split("  ");
  const r3 = r2.map((info) => {
    const s = info.split(" ");
    return [s[1], +s[0]];
  });

  return { id: line.id, t: r3 };
};

const checkColors = (line) => {
  const check = ([color, c]) => {
    return colors[color] >= c;
  };

  return line.t.every(check);
};

const sum = (tot, { id }) => {
  return tot + id;
};

const minimum = ({ t }) => {
  const max = { blue: 0, green: 0, red: 0 };

  return t.reduce((acc, [color, c]) => {
    const newMax = acc[color] > c ? {} : { [color]: c };

    return { ...acc, ...newMax };
  }, max);
};

const power = ({ blue, green, red }) => {
  return blue * green * red;
};

const sum2 = (tot, p) => {
  return tot + p;
};

// 1
// const result = input
//   .map(splitOnId)
//   .map(transform)
//   .filter(checkColors)
//   .reduce(sum, 0);

// 2
const result = input
  .map(splitOnId)
  .map(transform)
  .map(minimum)
  .map(power)
  .reduce(sum2, 0);

console.log(result);
