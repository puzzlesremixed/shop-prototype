@tool

extends Control

@export var is_modal_visible: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_modal_visible:
		_show_modal()
	else:
		_hide_modal()

func _show_modal() -> void:
	is_modal_visible = true
	visible = is_modal_visible

func _hide_modal() -> void:
	is_modal_visible = false
	visible = is_modal_visible

func _on_cancel_button_pressed() -> void:
	_hide_modal()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
