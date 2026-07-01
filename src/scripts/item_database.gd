extends Node


var all_items : Array[shop_items] = []

func _ready():
	load_items()
	
## loads all the shop items resources
func load_items() -> void:
	var dir: DirAccess = DirAccess.open("res://src/resources/shop_items/")
	
	if dir == null:
		push_error("Couldn't open item folder")
		return
	
	dir.list_dir_begin()
	
	while true:
		var file: String = dir.get_next()
		if file == "":
			break
		if file.ends_with(".tres"):
			var item = load("res://src/resources/shop_items/" + file)
			if item is shop_items:
				all_items.append(item)
	
	dir.list_dir_end()
