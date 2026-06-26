extends Node2D

@export var item_stats :shop_items
@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(item_stats.name)
	print(item_stats.texture)
	sprite.texture = item_stats.texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
