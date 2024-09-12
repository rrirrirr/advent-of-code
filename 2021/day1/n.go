package main

import (
	"math"
	"strconv"
	"strings"
)

func parseInput(input string) []int {
	lines := strings.Split(strings.TrimSpace(input), "\n")
	numbers := make([]int, 0, len(lines))

	for _, line := range lines {
		num, _ := strconv.Atoi(strings.TrimSpace(line))
		numbers = append(numbers, num)
	}

	return numbers
}

func SolveFirst(input string) int {
	numbers := parseInput(input)
	increasedFromBefore := 0
	lastNumber := math.MaxInt32

	for _, num := range numbers {
		if num > lastNumber {
			increasedFromBefore++
		}
		lastNumber = num
	}

	return increasedFromBefore
}

func SolveSecond(input string) int {
	numbers := parseInput(input)
	increasedFromBefore := 0
	lastWindow := math.MaxInt32
	breakPoint := len(numbers) - 2

	for i := 0; i < breakPoint; i++ {
		thisWindow := numbers[i] + numbers[i+1] + numbers[i+2]

		if thisWindow > lastWindow {
			increasedFromBefore++
		}
		lastWindow = thisWindow
	}

	return increasedFromBefore
}
