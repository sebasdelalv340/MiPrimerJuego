extends Node

@onready var score_label: Label = $ScoreLabel

func add_point():
	Score_manager.add_point()
	var score = Score_manager.get_score()
	score_label.text = "You collected " + str(score) + " coins."
