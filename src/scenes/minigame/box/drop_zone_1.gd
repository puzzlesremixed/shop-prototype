@tool
extends Area2D

enum PopupType {SUCCESS, DESTRUCTIVE, WARNING, INFO}

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
		show_popup("Task Completed!", 1.0, PopupType.SUCCESS)
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

func show_popup(text: String, duration_popup: float, type: PopupType = PopupType.INFO) -> void:
	# 1. Create the CanvasLayer so it locks to the screen
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	# 2. Create a CenterContainer to handle alignment automatically
	var center_container = CenterContainer.new()
	center_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT) # Fill the screen
	canvas_layer.add_child(center_container)
	
	# 3. Create the Label for the text
	var label = Label.new()
	label.text = text
	
	# Set up variables for dynamic styling
	var text_color: Color
	var font_size: int = 32
	
	# Match the type to assign specific colors and font sizes
	match type:
		PopupType.SUCCESS:
			text_color = Color("2ecc71") # Vibrant Green
			font_size = 36
		PopupType.DESTRUCTIVE:
			text_color = Color("e74c3c") # Vibrant Red
			font_size = 42 # Slightly larger for urgency
		PopupType.WARNING:
			text_color = Color("f1c40f") # Vibrant Yellow
			font_size = 36
		PopupType.INFO:
			text_color = Color("3498db") # Vibrant Blue
			font_size = 32 # Standard size
			
	# Apply the overrides
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", text_color)
	
	# Add a dark outline so bright colors pop against any game background
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 8)

	center_container.add_child(label)
	
	# 4. Animate it! (An elegant fade-in and fade-out)
	label.modulate.a = 0.0 # Start invisible
	
	var tween = create_tween()
	# Fade in over 0.3 seconds
	tween.tween_property(label, "modulate:a", 1.0, 0.3)
	# Wait for the specified duration
	tween.tween_interval(duration_popup)
	# Fade out over 0.5 seconds
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	
	# 5. Clean up everything automatically when the animation finishes
	tween.finished.connect(canvas_layer.queue_free)
