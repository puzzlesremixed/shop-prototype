extends Control

@export var options_modal: Control
@export var quit_confirmation_modal: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_options_button_pressed() -> void:
	if options_modal and options_modal.has_method("_show_modal"):
		options_modal._show_modal()

func _on_quit_button_pressed() -> void:
	if quit_confirmation_modal and quit_confirmation_modal.has_method("_show_modal"):
		quit_confirmation_modal._show_modal()
