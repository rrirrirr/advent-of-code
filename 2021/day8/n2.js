const processLine = (line) => {
  let positionCode = Array(7)
    .fill()
    .map(() => ["a", "b", "c", "d", "e", "f", "g"]);
  const processed = new Set();

  const removeLetters = (lettersToRemove, indexes) => {
    indexes.forEach((positionIndex) => {
      lettersToRemove.forEach((letter) => {
        positionCode[positionIndex] = positionCode[positionIndex].filter(
          (c) => c !== letter,
        );
      });
    });
  };

  const filterLetters = (letters, index) => {
    positionCode[index] = positionCode[index].filter((c) =>
      letters.includes(c),
    );
  };

  const filterPositions = (word) => {
    if (processed.has(word.length)) return;
    const charsInWord = word.split("");
    switch (word.length) {
      case 2: {
        removeLetters(charsInWord, [0, 3, 4, 5, 6]);
        filterLetters(charsInWord, 1);
        filterLetters(charsInWord, 2);
        processed.add(2);
        return;
      }
      case 3: {
        removeLetters(charsInWord, [3, 4, 5, 6]);
        filterLetters(charsInWord, 0);
        filterLetters(charsInWord, 1);
        filterLetters(charsInWord, 2);
        processed.add(3);
        return;
      }
      case 4: {
        removeLetters(charsInWord, [0, 3, 4]);
        filterLetters(charsInWord, 1);
        filterLetters(charsInWord, 2);
        filterLetters(charsInWord, 6);
        filterLetters(charsInWord, 5);
        processed.add(4);
        return;
      }
      case 5: {
        if (positionCode[1].every((char) => charsInWord.includes(char))) {
          removeLetters(charsInWord, [4, 5]);
          filterLetters(charsInWord, 3);
          filterLetters(charsInWord, 6);
          processed.add(5);
        }
        return;
      }
      case 6: {
        if (
          [positionCode[5][0], positionCode[4][0]].every((char) =>
            charsInWord.includes(char),
          ) &&
          !positionCode[1].every((char) => charsInWord.includes(char))
        ) {
          removeLetters(charsInWord, [1]);
          filterLetters(charsInWord, 2);
          processed.add(6);
          return;
        }
      }
      default:
        return;
    }
  };

  const words = Array(10)
    .fill()
    .map(() => new Set());

  const [patterns, output] = line.split(" | ");
  patterns.split(" ").forEach((word) => {
    if (!word) return;
    const sortedWord = word.split("").sort().join("");
    words[word.length].add(sortedWord);
  });

  [...words[2], ...words[3], ...words[4], ...words[5], ...words[6]].forEach(
    (word) => filterPositions(word),
  );

  const getSegments = (indexes) =>
    indexes
      .map((i) => positionCode[i])
      .sort()
      .join("");

  const map = {
    [getSegments([0, 1, 2, 3, 4, 5])]: "0",
    [getSegments([1, 2])]: "1",
    [getSegments([0, 1, 6, 4, 3])]: "2",
    [getSegments([0, 1, 2, 3, 6])]: "3",
    [getSegments([5, 6, 1, 2])]: "4",
    [getSegments([0, 5, 6, 2, 3])]: "5",
    [getSegments([0, 5, 6, 4, 2, 3])]: "6",
    [getSegments([0, 1, 2])]: "7",
    [getSegments([0, 1, 2, 3, 4, 5, 6])]: "8",
    [getSegments([0, 1, 2, 3, 5, 6])]: "9",
  };

  return output
    .split(" ")
    .filter(Boolean)
    .map((word) => map[word.split("").sort().join("")])
    .join("");
};

const lines = await Bun.file("input")
  .text()
  .then((v) => v.split("\n").filter(Boolean));

const res = lines.map(processLine).reduce((tot, v) => tot + Number(v), 0);
console.log(res);
