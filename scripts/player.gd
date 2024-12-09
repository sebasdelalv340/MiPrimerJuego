extends CharacterBody2D


const SPEED = 120.0
const JUMP_VELOCITY = -300.0

var direction = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var fruta:PackedScene

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
		
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fruta"):
		var newFruta = fruta.instantiate()
		newFruta.position = self.position + Vector2(0, -10)
		newFruta.isFlip = animated_sprite.flip_h
	
		add_sibling(newFruta)
