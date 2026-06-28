extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var shopping_list: Array[shop_items]
var state = [
	"ENTERING",
	"SHOPPING",
	"QUEUEING",
	"WAITING_CASHIER",
	"LEAVING"
	]
var cashier_wait_patience : int

func _ready() -> void:
	animated_sprite_2d.play("Idle_Down")
