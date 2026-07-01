extends Area2D

@export var max_items: int = 4

@onready var submitted_items: int = 0
@onready var scan_line: Node2D = $ScanLine

func submit(item: Area2D) -> void:
	submitted_items += 1
	item.sfx_drop.play()
	await item.sfx_drop.finished
	item.queue_free()

	if submitted_items == max_items:
		finish_minigame()
	
func finish_minigame() -> void:
	SplashUI.show_popup("Task Completed!", 1.0, SplashUI.PopupType.SUCCESS)
	$SFX_Complete.play()

func _on_scanner_area_entered(item: Area2D) -> void:
	if item.scanned:
		return

	# Animate Scanline Up and Down
	var tween = create_tween()
	var tween_speed = item.scan_duration * 0.25
	tween.tween_property(scan_line, "position", Vector2(0, 0), tween_speed) \
		.as_relative() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(scan_line, "position", Vector2(0, 65), tween_speed) \
		.as_relative() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN)

	tween.tween_property(scan_line, "position", Vector2(0, -65), tween_speed) \
		.as_relative() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN)

	item.scan()


func _on_scanner_area_exited(item: Area2D) -> void:
	item.cancel_scan()
