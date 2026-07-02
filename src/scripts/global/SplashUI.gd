extends Node2D

enum PopupType {SUCCESS, DESTRUCTIVE, WARNING, INFO}

func show_popup(text: String, duration_popup: float, type: PopupType = PopupType.INFO) -> void:
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	canvas_layer.layer = 128
	var center_container = CenterContainer.new()
	center_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas_layer.add_child(center_container)
	
	var label = Label.new()
	label.text = text
	
	var text_color: Color
	var font_size: int = 32
	
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
			
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", text_color)
	
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 8)

	center_container.add_child(label)
	
	label.modulate.a = 0.0
	
	var tween = create_tween()
	
	tween.tween_property(label, "modulate:a", 1.0, 0.3)
	tween.tween_interval(duration_popup)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)

	tween.finished.connect(canvas_layer.queue_free)
