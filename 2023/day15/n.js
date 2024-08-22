const input = await Bun.file("input")
  .text()
  .then((v) => v.replaceAll("\n", "").split(","));

const HASH = (str) => {
  return str.split("").reduce((tot, c) => {
    return ((tot + c.charCodeAt(0)) * 17) % 256;
  }, 0);
};

const res = input.map(HASH).reduce((tot, n) => tot + n);
console.log(res);
