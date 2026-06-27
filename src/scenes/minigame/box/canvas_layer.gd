extends CanvasLayer

func _ready() -> void:
	hide()

func display() -> void:
	show()
	get_tree().paused = true
