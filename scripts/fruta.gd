extends Node2D

var velocity = Vector2(150, -100)
var gravity = 9.8

var isFlip = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if isFlip:
		velocity.x *= -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.y += gravity
	position += velocity * delta
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.get_parent().queue_free()
		self.queue_free()
	
