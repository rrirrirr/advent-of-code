const rawinput = Bun.file("input");

const input = await rawinput.text();

const sections = input.split(/\n\n/);

console.log(sections.map((section) => section.split("\n").map(Number)));
