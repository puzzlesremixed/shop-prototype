extends CharacterBody2D

@export var SPEED = 300.0

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement.
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	

	move_and_slide()
