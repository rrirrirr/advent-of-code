import { init } from "z3-solver";
import fs from "fs";

const text = fs.readFileSync("input", "utf-8").split("\n").filter(Boolean); // Split by line and filter out empty lines

const input = text.map((row) => {
  const [positions, velocities] = row
    .split("@")
    .map((part) => part.split(",").map(Number)); // Split each part and convert to numbers
  return [positions, velocities];
});

const { Context } = await init();
const { Solver, Int } = new Context("main");

const solver = new Solver();

const rx = Int.const("rx");
const ry = Int.const("ry");
const rz = Int.const("rz");
const rvx = Int.const("rvx");
const rvy = Int.const("rvy");
const rvz = Int.const("rvz");

input.forEach(([[px, py, pz], [vx, vy, vz]], i) => {
  const t = Int.const(`t${i}`);

  const pxI = Int.val(px);
  const pyI = Int.val(py);
  const pzI = Int.val(pz);
  const vxI = Int.val(vx);
  const vyI = Int.val(vy);
  const vzI = Int.val(vz);

  solver.add(rx.add(rvx.mul(t)).eq(pxI.add(vxI.mul(t))));
  solver.add(ry.add(rvy.mul(t)).eq(pyI.add(vyI.mul(t))));
  solver.add(rz.add(rvz.mul(t)).eq(pzI.add(vzI.mul(t))));
});

const isSat = await solver.check();

if (isSat) {
  const model = solver.model();
  const res =
    Number(model.eval(rx)) + Number(model.eval(ry)) + Number(model.eval(rz));

  console.log(res);
} else {
  console.log("not sat");
}
