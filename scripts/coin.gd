extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Score_manager.add_point()
	queue_free()
