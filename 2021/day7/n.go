package main

import (
	"math"
	"strconv"
	"strings"
)

func parseInput(input string) []int {
	nums := strings.Split(strings.TrimSpace(input), ",")
	numbers := make([]int, 0, len(nums))

	for _, v := range nums {
		num, _ := strconv.Atoi(v)
		numbers = append(numbers, num)
	}

	return numbers
}

func min(nums []int) int {
	minVal := nums[0]
	for _, v := range nums {
		if v < minVal {
			minVal = v
		}
	}
	return minVal
}

func max(nums []int) int {
	maxVal := nums[0]
	for _, v := range nums {
		if v > maxVal {
			maxVal = v
		}
	}
	return maxVal
}

func abs(a int) int {
	if a < 0 {
		return -a
	}
	return a
}

func SolveFirst(input string) int {
	positions := parseInput(input)
	minFuel := math.MaxInt
	minPos := min(positions)
	maxPos := max(positions)

	for i := minPos; i <= maxPos; i++ {
		cost := 0
		for _, pos := range positions {
			cost += abs(pos - i)
		}
		if cost < minFuel {
			minFuel = cost
		}
	}

	return minFuel
}

func SolveSecond(input string) int {
	positions := parseInput(input)
	minFuel := math.MaxInt
	minPos := min(positions)
	maxPos := max(positions)
	costs := make([]int, maxPos+1)

	for i := 1; i <= maxPos; i++ {
		costs[i] = costs[i-1] + i
	}

	for i := minPos; i <= maxPos; i++ {
		cost := 0
		for _, pos := range positions {
			delta := abs(pos - i)
			cost += costs[delta]
		}
		if cost < minFuel {
			minFuel = cost
		}
	}

	return minFuel
}
