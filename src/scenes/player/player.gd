extends CharacterBody2D

@export var SPEED := 300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# This face up by default
@onready var interaction_area: Area2D = $InteractionArea 
var last_facing := "Up"

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")

	# horizontal priority
	if input_dir.x != 0:
		input_dir.y = 0
	elif input_dir.y != 0:
		input_dir.x = 0
		
	# Restrict movement to 4 directions
	if abs(input_dir.x) > abs(input_dir.y):
		input_dir.y = 0
	else:
		input_dir.x = 0
		
		
	velocity = input_dir * SPEED

	if input_dir != Vector2.ZERO:
		var new_facing = get_facing_direction(input_dir)

		if new_facing != last_facing:
			last_facing = new_facing
			update_interaction_area()

		animated_sprite.play("Walk_" + last_facing)
	else:
		animated_sprite.play("Idle_" + last_facing)

	move_and_slide()


func get_facing_direction(dir: Vector2) -> String:
	if dir.x > 0:
		return "Right"
	elif dir.x < 0:
		return "Left"
	elif dir.y > 0:
		return "Down"
	else:
		return "Up"

func update_interaction_area() -> void:
	match last_facing:
		"Up":
			interaction_area.rotation_degrees = 0
		"Right":
			interaction_area.rotation_degrees = 90
		"Down":
			interaction_area.rotation_degrees = 180
		"Left":
			interaction_area.rotation_degrees = -90

func _on_interaction_area_body_entered(body: Node2D) -> void:
	print(body)
