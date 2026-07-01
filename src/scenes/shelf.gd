extends StaticBody2D
class_name Shelf

@export var items: Array[ShelfSlot]
var shop_item_scene: PackedScene = preload("uid://dokivvfnee0bw")

@onready var navi_target: Marker2D = $NaviTarget

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



	
func take_item(item: shop_items) -> bool:
	for slot in slots:
		if slot.item == item and slot.stock > 0:
			slot.stock -= 1
			#update_visuals()
			return true
	return false

func refill(item: shop_items, amount: int):
	for slot in slots:
		if slot.item == item:
			slot.stock = min(slot.capacity, slot.stock + amount)
			#update_visuals()
			return

func _ready():
	var count := mini(items.size(), slots.size())	
	for i in range(count):
		if items[i] != null:
			var item: Node = shop_item_scene.instantiate()
			item.item_stats = items[i].item
			slots[i].add_child(item)

func take_requested_items(shopping_list : Array[shop_items]) -> Array[shop_items]:
	var found_items : Array[shop_items]

	for item in items:
		if item.item != null and item.stock > 0 and shopping_list.has(item.item):
			print("Found matching item in slot: ", item.item.name)
			item.stock -= 1
			found_items.append(item.item)
			
	return found_items


func contains(item: shop_items) -> bool:
	for slot in slots:
		if slot.item == item and slot.stock > 0:
			return true
	return false
