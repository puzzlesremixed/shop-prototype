extends Node2D

var shake_tween: Tween

@onready var root_node: Node2D = $"../ScanMinigame"
@onready var base_position: Vector2

@export var intensity_invalid_cam_shake: float = 12.0
@export var duration_invalid_cam_shake: float = 0.3

func _ready() -> void:
	if (root_node):
		base_position = root_node.position

func play_camera_shake() -> void:
	# Cancel any active shake if the player spams the error
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()
		root_node.position = base_position
		
	# Create a new Tween
	shake_tween = create_tween()
	
	# Calculate how fast each individual "jerk" of the shake should be
	var shake_steps: int = 6
	var step_duration: float = duration_invalid_cam_shake / shake_steps
	
	# Generate random jerky movements
	for i in range(shake_steps):
		var random_offset = Vector2(
			randf_range(-intensity_invalid_cam_shake, intensity_invalid_cam_shake),
			randf_range(-intensity_invalid_cam_shake, intensity_invalid_cam_shake)
		)
		# Tween to the random offset
		shake_tween.tween_property(root_node, "position", base_position + random_offset, step_duration).set_trans(Tween.TRANS_SINE)
		
	# Return the node to its original position at the end
	shake_tween.tween_property(root_node, "position", base_position, step_duration).set_trans(Tween.TRANS_SINE)
