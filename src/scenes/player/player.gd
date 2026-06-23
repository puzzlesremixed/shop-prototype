extends CharacterBody2D

@export var SPEED := 300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var last_facing := "Down"

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED

	if direction != Vector2.ZERO:
		last_facing = get_facing_direction(direction)
		animated_sprite.play("Walk_" + last_facing)
	else:
		animated_sprite.play("Idle_" + last_facing)

	move_and_slide()


func get_facing_direction(dir: Vector2) -> String:
	# Prioritize dominant axis to avoid diagonal ambiguity
	if abs(dir.x) > abs(dir.y):
		return "Right" if dir.x > 0 else "Left"
	else:
		return "Down" if dir.y > 0 else "Up"
