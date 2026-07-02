extends Area2D

signal minigame_finished

enum MopTileType {DIRTY, CLEAN}

@export var dirt_level: int = 100
@export var finish_animation: AnimationPlayer;
@export var mop: Node2D;

var completed: bool = false

const SPRITES = {
	MopTileType.DIRTY: preload("res://assets/sprites/minigame/mop/mop_tile_dirty.png"),
	MopTileType.CLEAN: preload("res://assets/sprites/minigame/mop/mop_tile_clean.png"),
}

@onready var mop_tile_sprite: Sprite2D = $MopTileMask/MopTile

func set_transition_percentage(percent: float):
	var clamped_percent = clamp(percent, 0.0, 100.0)
	var blend_value = clamped_percent / 100.0
	mop_tile_sprite.material.set_shader_parameter("blend_amount", blend_value)

func clean(increment_amount: int) -> void:
	if completed:
		return
	
	dirt_level -= increment_amount
	set_transition_percentage(100.0 - float(dirt_level))

	if dirt_level <= 0:
		completed = true
		mop.disabled = true
		SplashUI.show_popup("Task Completed!", 1.0, SplashUI.PopupType.SUCCESS)
		$SFX_Complete.play()
		finish_animation.play("slide_out")
		minigame_finished.emit()
		return
