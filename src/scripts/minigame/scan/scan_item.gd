@tool
class_name ScanItem
extends Area2D

enum ItemType {MILK, CARROT, SHAMPOO, SNACK, TOOTHBRUSH}

const SPRITES = {
	ItemType.MILK: preload("res://assets/sprites/shop_items/milk_carton.png"),
	ItemType.CARROT: preload("res://assets/sprites/shop_items/carrot.png"),
	ItemType.SHAMPOO: preload("res://assets/sprites/shop_items/shampoo.png"),
	ItemType.SNACK: preload("res://assets/sprites/shop_items/snack.png"),
	ItemType.TOOTHBRUSH: preload("res://assets/sprites/shop_items/toothbrush.png"),
}

var is_dragging: bool = false
var mouse_offset: Vector2 = Vector2.ZERO
var scanned: bool = false
var _scan_id: int = 0

@onready var original_position: Vector2 = global_position
@onready var sfx_drop: AudioStreamPlayer = $SFX_Drop

@export var scan_duration: float = 0.6
@export var item_type: ItemType = ItemType.MILK:
	set(value):
		item_type = value
		_update_sprite()

func _ready() -> void:
	input_pickable = true
	_update_sprite()

func _update_sprite() -> void:
	var sprite = $Sprite2D
	sprite.texture = SPRITES[item_type]

func _input_event(viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			$SFX_Click.play()
			mouse_offset = global_position - get_global_mouse_position()
			
			# Pop it to the front layer while dragging
			z_index = 100
			
			# Stop the input from clicking items buried underneath this one
			viewport.set_input_as_handled()
			var overlapping_areas = get_overlapping_areas()
			for area in overlapping_areas:
				if area.is_in_group("drop_zones"):
					area.clear_zone()


func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() + mouse_offset

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if is_dragging:
			is_dragging = false

			# Reset layer depth
			z_index = 0
			
			_try_drop_item()


func _try_drop_item() -> void:
	var overlapping_areas = get_overlapping_areas()
	var successfully_placed = false
	
	for area in overlapping_areas:
		if area.is_in_group("bag_dropzone"):
			if scanned:
				# Snap to the center of the shelf slot
				global_position = area.global_position
				area.submit(self)
				successfully_placed = true

			else:
				SplashUI.show_popup("Scan Item First!", 1.0, SplashUI.PopupType.DESTRUCTIVE)
				$SFX_InvalidPlacement.play()
				ScanManager.play_camera_shake()
							
	if not successfully_placed:
		# Smoothly slide back to the basket
		var tween = create_tween()
		tween.tween_property(self, "global_position", original_position, 0.25) \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_OUT)

func scan() -> void:
	if scanned:
		return # Prevent re-scanning an already scanned item
		
	_scan_id += 1
	var current_scan_id = _scan_id

	# Wait for scan duration
	await get_tree().create_timer(scan_duration).timeout
	
	# If the ID changed while we were waiting, it means the item exited the zone
	if current_scan_id == _scan_id:
		$SFX_Scan.play()
		scanned = true

func cancel_scan() -> void:
	# Incrementing the ID acts as a cancellation. 
	# The previous timer will still finish, but it will fail the "if" check.
	_scan_id += 1
