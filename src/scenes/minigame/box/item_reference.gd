@tool
extends Node2D

@onready var root_node: Node2D = $"../BoxMinigame"
@onready var base_position: Vector2

@export var intensity_invalid_cam_shake: float = 12.0
@export var duration_invalid_cam_shake: float = 0.3

@export var targets: Array[ShopItem.ItemType] = [
	ShopItem.ItemType.MILK,
	ShopItem.ItemType.CARROT,
	ShopItem.ItemType.SHAMPOO,
	ShopItem.ItemType.SNACK,
	]:
	set(value):
		targets = value
		_update_visuals()

		if value.size() > 4:
			print("Too many targets!")
			value.resize(4)
	
		targets = value

var shake_tween: Tween

func _ready() -> void:
	_update_visuals()
	if (root_node):
		base_position = root_node.position

func _update_visuals() -> void:
	for child in get_children():
		var sprite := child as Sprite2D
		if sprite:
			var idx: int = sprite.get_index()
			sprite.texture = ShopItem.SPRITES[targets[idx]]

func play_camera_shake() -> void:
	# 1. Cancel any active shake if the player spams the error
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()
		root_node.position = base_position
		
	# 2. Create a new Tween
	shake_tween = create_tween()
	
	# 3. Calculate how fast each individual "jerk" of the shake should be
	var shake_steps: int = 6
	var step_duration: float = duration_invalid_cam_shake / shake_steps
	
	# 4. Generate random jerky movements
	for i in range(shake_steps):
		var random_offset = Vector2(
			randf_range(-intensity_invalid_cam_shake, intensity_invalid_cam_shake),
			randf_range(-intensity_invalid_cam_shake, intensity_invalid_cam_shake)
		)
		# Tween to the random offset
		shake_tween.tween_property(root_node, "position", base_position + random_offset, step_duration).set_trans(Tween.TRANS_SINE)
		
	# 5. Crucial: Always return the node to its original position at the end
	shake_tween.tween_property(root_node, "position", base_position, step_duration).set_trans(Tween.TRANS_SINE)
