package main

import (
	"fmt"
	"os"
	"testing"
)

func readFile(filename string) string {
	content, _ := os.ReadFile(filename)
	return string(content)
}

func TestN(t *testing.T) {
	input := readFile("input")
	testInput := readFile("testInput")

	t.Run("first part with test input", func(t *testing.T) {
		got := SolveFirst(testInput)
		want := 37

		if got != want {
			t.Errorf("got %d want %d", got, want)
		} else {
			fmt.Printf("%d: solution part 1 test input \n", got)
		}
	})

	t.Run("first part with real input", func(t *testing.T) {
		got := SolveFirst(input)
		want := 356958 // already known solution

		if got != want {
			t.Errorf("got %d want %d", got, want)
		} else {
			fmt.Printf("%d: solution part 1 \n", got)
		}
	})

	t.Run("second part with test input", func(t *testing.T) {
		got := SolveSecond(testInput)
		want := 168

		if got != want {
			t.Errorf("got %d want %d", got, want)
		} else {
			fmt.Printf("%d: solution part 2 test input \n", got)
		}
	})

	t.Run("second part with real input", func(t *testing.T) {
		got := SolveSecond(input)
		want := 105461913 // already known solution

		if got != want {
			t.Errorf("got %d want %d", got, want)
		} else {
			fmt.Printf("%d: solution part 2 test input \n", got)
		}
	})

}
