// const fs = require('node:fs')
// const path = require('node:path')

import { readFileSync } from "node:fs";

try {
  const f = readFileSync("./input", { encoding: "utf8", flag: "r" });
  console.log(f);
} catch (err) {
  console.log(error);
}
