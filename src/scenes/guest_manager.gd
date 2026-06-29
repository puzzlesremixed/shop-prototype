extends Node
class_name GuestManager

@export var guest_scene : PackedScene
@export var spawn_point : Marker2D
@onready var rating_system: RatingSystem = $"../RatingSystem"


var spawn_timer := 0.0

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0:
		try_spawn_guest()
		spawn_timer = 3.0

func try_spawn_guest() -> void:
	print_debug("Spawning guest..")
	var rating: int = rating_system.current_rating
	var spawn_probability = lerp(0.10, 0.95, rating / 100.0)
	if randf() > spawn_probability:
		return
	spawn_guest()
	
func spawn_guest():
	var guest: Node = guest_scene.instantiate()
	guest.global_position = spawn_point.global_position
	guest.shopping_list = generate_shopping_list()
	add_child(guest)
	
func generate_shopping_list() -> Array[shop_items]:

	var result : Array[shop_items] = []
	var item_count: int = randi_range(1, 5)
	var available = ItemDatabase.all_items.duplicate()
	available.shuffle()
	
	for i in min(item_count, available.size()):
		result.append(available[i])

	print("Spawned guests with list:", result)	
	return result
