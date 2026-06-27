extends Node2D

enum PopupType {SUCCESS, DESTRUCTIVE, WARNING, INFO}

func show_popup(text: String, duration_popup: float, type: PopupType = PopupType.INFO) -> void:
	# Create the CanvasLayer so it locks to the screen
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	# Create a CenterContainer to handle alignment automatically
	var center_container = CenterContainer.new()
	center_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT) # Fill the screen
	canvas_layer.add_child(center_container)
	
	# Create the Label for the text
	var label = Label.new()
	label.text = text
	
	# Set up variables for dynamic styling
	var text_color: Color
	var font_size: int = 32
	
	# Match the type to assign specific colors and font sizes
	match type:
		PopupType.SUCCESS:
			text_color = Color("2ecc71")
			font_size = 36
		PopupType.DESTRUCTIVE:
			text_color = Color("e74c3c")
			font_size = 42
		PopupType.WARNING:
			text_color = Color("f1c40f")
			font_size = 36
		PopupType.INFO:
			text_color = Color("3498db")
			font_size = 32
			
	# Apply the overrides
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", text_color)
	
	# Add a dark outline so bright colors pop against any game background
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 8)

	center_container.add_child(label)
	
	# Start Animations
	label.modulate.a = 0.0 # Start invisible
	
	var tween = create_tween()
	# Fade in over 0.3 seconds
	tween.tween_property(label, "modulate:a", 1.0, 0.3)
	# Wait for the specified duration
	tween.tween_interval(duration_popup)
	# Fade out over 0.5 seconds
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	
	# Clean up everything automatically when the animation finishes
	tween.finished.connect(canvas_layer.queue_free)
