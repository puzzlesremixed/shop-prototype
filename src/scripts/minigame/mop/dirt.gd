@tool
class_name Dirt

extends Area2D

signal minigame_finished

enum StainVariant {STAIN_1, STAIN_2, STAIN_3}

@export var dirt_level: int = 100
@export var variant: StainVariant = StainVariant.STAIN_1;
@export var finish_animation: AnimationPlayer;
@export var mop: Area2D;
@export var minigame_instance: CanvasLayer
@export var second_visual_feedback: Sprite2D;

var completed: bool = false
var tween = create_tween()

const SPRITES = {
	StainVariant.STAIN_1: preload("res://assets/sprites/minigame/mop/stain_1.png"),
	StainVariant.STAIN_2: preload("res://assets/sprites/minigame/mop/stain_2.png"),
	StainVariant.STAIN_3: preload("res://assets/sprites/minigame/mop/stain_3.png"),
}

@onready var mop_tile_sprite: Sprite2D = $Sprite2D

func update_sprite() -> void:
	mop_tile_sprite.texture = SPRITES[variant]

func set_transition_percentage(percentage: float):
	var safe_percentage = clamp(percentage, 0.0, 100.0)
	var alpha_value = 1.0 - (safe_percentage / 100.0)
	modulate.a = alpha_value
	if second_visual_feedback:
		second_visual_feedback.modulate.a = alpha_value

func clean(increment_amount: int) -> void:
	if completed:
		return
	
	dirt_level -= increment_amount
	set_transition_percentage(100.0 - float(dirt_level))

	if dirt_level <= 0:
		completed = true
		SplashUI.show_popup("Task Completed!", 1.0, SplashUI.PopupType.SUCCESS)
		$SFX_Complete.play()
		finish_animation.play("slide_out")
		minigame_finished.emit()
		mop.disabled = true;
		await finish_animation.animation_finished
		minigame_instance.queue_free()
		return
