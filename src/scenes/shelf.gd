extends StaticBody2D

@export var items : Array[shop_items]
var shop_item_scene: PackedScene = preload("uid://dokivvfnee0bw")

@onready var _1_1: Marker2D = $"MarkerGroup/Row 1/1_1"
@onready var _1_2: Marker2D = $"MarkerGroup/Row 1/1_2"
@onready var _1_3: Marker2D = $"MarkerGroup/Row 1/1_3"

@onready var _2_1: Marker2D = $"MarkerGroup/Row 2/2_1"
@onready var _2_2: Marker2D = $"MarkerGroup/Row 2/2_2"
@onready var _2_3: Marker2D = $"MarkerGroup/Row 2/2_3"

@onready var _3_1: Marker2D = $"MarkerGroup/Row 3/3_1"
@onready var _3_2: Marker2D = $"MarkerGroup/Row 3/3_2"
@onready var _3_3: Marker2D = $"MarkerGroup/Row 3/3_3"

@onready var slots := [
	_1_1,
	_1_2,
	_1_3,
	_2_1,
	_2_2,
	_2_3,
	_3_1,
	_3_2,
	_3_3,
]

func _ready():
	var count := mini(items.size(), slots.size())
	
	for i in range(count):
		if items[i] != null:
			var item = shop_item_scene.instantiate()
			item.item_stats = items[i]
			#item.position = slots[i].position
			print("Item [" , i, "], Marker Pos : ", slots[i].position, ", Actual scene pos: ", item.position )
			#item.z_index = 3
			slots[i].add_child(item)
