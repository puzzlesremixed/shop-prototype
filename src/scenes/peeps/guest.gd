extends CharacterBody2D
class_name Guest

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var shopping_list: Array[shop_items]

var state: Array[Variant] = [
	"ENTERING",
	"SHOPPING",
	"QUEUEING",
	"WAITING_CASHIER",
	"LEAVING"
	]
	
var cashier_wait_patience : int

func _ready() -> void:
	animated_sprite.play("Idle_Down")

#res://src/resources/shop_items/
