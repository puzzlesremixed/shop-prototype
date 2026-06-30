extends Node
class_name GuestManager

@export var guest_scene : PackedScene
@export var spawn_point : Marker2D
@onready var rating_system: RatingSystem = $"../RatingSystem"
@onready var path: TileMapLayer = $"../Shop1/Path"

@onready var shelf_row  : ShelfRowScene = $"../Shop1/Shelfs/ShelfRow"
@onready var shelf_row_2 : ShelfRowScene = $"../Shop1/Shelfs/ShelfRow2"
@onready var shelf_row_3 : ShelfRowScene= $"../Shop1/Shelfs/ShelfRow3"

@onready var shelf_rows =[
	shelf_row, shelf_row_2, shelf_row_3
]

var spawn_timer := 0.0

func _ready() -> void:
	pass

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0:
		try_spawn_guest()
		spawn_timer = 3.0

func try_spawn_guest() -> void:
	var rating: int = rating_system.current_rating
	var spawn_probability = lerp(0.10, 0.95, rating / 1000.0)
	if randf() > spawn_probability:
		return
	print("Spawning guest..")
	spawn_guest()
	
func spawn_guest():
	shelf_rows.shuffle()
	var guest: Guest = guest_scene.instantiate()
	guest.destination = shelf_rows[0].shelfs_members[0]
	guest.tilemap_layer = path
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

	return result
