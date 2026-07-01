extends Area2D

enum MopTileType {DIRTY, CLEAN}

@export var dirt_level: int = 100
var completed: bool = false

const SPRITES = {
	MopTileType.DIRTY: preload("res://assets/sprites/minigame/mop/mop_tile_dirty.png"),
	MopTileType.CLEAN: preload("res://assets/sprites/minigame/mop/mop_tile_clean.png"),
}

@onready var mop_tile_sprite: Sprite2D = $MopTileMask/MopTile

func set_transition_percentage(percent: float):
	# Ensure the number stays between 0 and 100
	var clamped_percent = clamp(percent, 0.0, 100.0)
	
	# Convert the 0-100 percentage to a 0.0-1.0 float for the shader
	var blend_value = clamped_percent / 100.0
	
	# Send the value to the shader
	mop_tile_sprite.material.set_shader_parameter("blend_amount", blend_value)

func clean(increment_amount: int) -> void:
	if completed:
		return
	
	dirt_level -= increment_amount
	set_transition_percentage(100.0 - float(dirt_level))

	if dirt_level <= 0:
		completed = true
		SplashUI.show_popup("Task Completed!", 1.0, SplashUI.PopupType.SUCCESS)
		$SFX_Complete.play()
		return
