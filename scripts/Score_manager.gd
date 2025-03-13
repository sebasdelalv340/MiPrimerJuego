extends Node

var score = 0

func add_point():
	score += 1

func get_score() -> int:
	return score

func set_score(value: int):
	score = value
