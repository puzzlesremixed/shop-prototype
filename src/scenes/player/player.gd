class_name Player

extends CharacterBody2D

enum MinigameTransitionSide {LEFT, RIGHT, CENTER}

@export var SPEED := 300.0
@export var minigame_cam_transition_offset: Vector2 = Vector2(250, 0)
@export var minigame_cam_transition_duration: float = 0.6

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $InteractionArea

var last_facing := "Up"
var in_minigame: bool = false
var camera_tween: Tween
var camera: Camera2D

func _ready() -> void:
	camera = get_viewport().get_camera_2d()

func _physics_process(_delta: float) -> void:
	if in_minigame:
		return

	var input_dir := Input.get_vector("left", "right", "up", "down")

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

func shift_camera_minigame(minigame_transition_side: MinigameTransitionSide) -> void:
	if camera:
		if camera_tween and camera_tween.is_running():
			camera_tween.kill()
			
		camera_tween = create_tween()

		if minigame_transition_side == MinigameTransitionSide.LEFT:
			camera_tween.tween_property(camera, "offset", -minigame_cam_transition_offset, minigame_cam_transition_duration) \
				.set_trans(Tween.TRANS_LINEAR)

		elif minigame_transition_side == MinigameTransitionSide.RIGHT:
			camera_tween.tween_property(camera, "offset", minigame_cam_transition_offset, minigame_cam_transition_duration) \
				.set_trans(Tween.TRANS_LINEAR)

		elif minigame_transition_side == MinigameTransitionSide.CENTER:
			camera_tween.tween_property(camera, "offset", Vector2.ZERO, minigame_cam_transition_duration) \
				.set_trans(Tween.TRANS_LINEAR)
