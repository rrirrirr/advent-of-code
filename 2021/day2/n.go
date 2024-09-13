package main

import (
	"strconv"
	"strings"
)

func parseInput(input string) [][2]interface{} {
	lines := strings.Split(strings.TrimSpace(input), "\n")
	instructions := make([][2]interface{}, 0, len(lines))
	for _, line := range lines {
		parts := strings.Split(line, " ")
		direction := parts[0]
		length, _ := strconv.Atoi(parts[1])
		instructions = append(instructions, [2]interface{}{direction, length})
	}
	return instructions
}

func SolveFirst(input string) int {
	instructions := parseInput(input)
	depth := 0
	hpos := 0
	for _, instruction := range instructions {
		direction := instruction[0].(string)
		length := instruction[1].(int)
		switch direction {
		case "forward":
			hpos += length
		case "down":
			depth += length
		case "up":
			depth -= length
		}
	}
	return hpos * depth
}

func SolveSecond(input string) int {
	instructions := parseInput(input)
	depth := 0
	hpos := 0
	aim := 0
	for _, instruction := range instructions {
		direction := instruction[0].(string)
		length := instruction[1].(int)
		switch direction {
		case "forward":
			hpos += length
			depth += aim * length
		case "down":
			aim += length
		case "up":
			aim -= length
		}
	}
	return hpos * depth
}
