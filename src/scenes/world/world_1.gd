extends Node2D

@onready var money_system: MoneySystem = $MoneySystem
@export var shop_resource : shop


func _ready() -> void:
	money_system.update_balance(shop_resource.starting_money);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
