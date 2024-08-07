const line = "vJrwpWtwJgWrhcsFMMfFFhFp";

const mid = line.length / 2;
const a = line.slice(0, mid);
const b = [...line.slice(mid, line.length)];

console.log(a, b);
