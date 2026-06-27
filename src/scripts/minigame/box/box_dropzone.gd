@tool
extends Area2D

@export var acceptable: ShopItem.ItemType = ShopItem.ItemType.MILK
@export var show_arrows: bool = true
@export var bounce_height: float = 20.0
@export var duration: float = 0.6

@onready var arrow_sprite = $Sprite2D

var is_occupied: bool = false
var current_item: Area2D = null

func _ready() -> void:
	if show_arrows:
		start_arrow_bounce_animation()

func occupy_zone(item: Area2D) -> void:
	is_occupied = true
	arrow_sprite.visible = false
	current_item = item

	var manager = get_parent() as DropZoneManager
	if manager and manager.is_complete():
		SplashUI.show_popup("Task Completed!", 1.0, SplashUI.PopupType.SUCCESS)
		$SFX_Complete.play()

func clear_zone() -> void:
	is_occupied = false
	arrow_sprite.visible = true
	current_item = null

func start_arrow_bounce_animation() -> void:
	# Calculate the top and bottom positions based on current position
	if arrow_sprite:
		var start_pos = arrow_sprite.position
		var top_pos = start_pos + Vector2(0, -bounce_height)
		
		# Create a looping tween
		var tween = create_tween().set_loops()
		
		# Move up smoothly (Ease Out)
		tween.tween_property(arrow_sprite, "position", top_pos, duration) \
			.set_trans(Tween.TRANS_QUAD) \
			.set_ease(Tween.EASE_OUT)
			
		# Move back down smoothly (Ease In)
		tween.tween_property(arrow_sprite, "position", start_pos, duration) \
			.set_trans(Tween.TRANS_QUAD) \
			.set_ease(Tween.EASE_IN)
