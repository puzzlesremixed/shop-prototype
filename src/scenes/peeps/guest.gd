extends CharacterBody2D
class_name Guest

# todo
#var state: Array[Variant] = [
	#"ENTERING",
	#"SHOPPING",
	#"QUEUEING",
	#"WAITING_CASHIER",
	#"LEAVING"
	#]
	
#	should be a timer
#var cashier_wait_patience : int

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var shopping_list: Array[shop_items]

@export var debug_pathfind_line : Line2D ;

var TILE_SIZE: int = 32;
var tilemap_layer: TileMapLayer;
var destination: Shelf;

var pathfinding_grid :  AStarGrid2D = AStarGrid2D.new()
var path_to_destination : Array = [];



func _ready() -> void:
	animated_sprite.play("Idle_Down")
	
	if debug_pathfind_line:
		debug_pathfind_line.global_position = Vector2.ZERO
	
	# Configure your basic grid sizing layout
	pathfinding_grid.region = tilemap_layer.get_used_rect()
	pathfinding_grid.cell_size = Vector2(TILE_SIZE, TILE_SIZE)
	pathfinding_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	pathfinding_grid.update() 
	
	# STEP 1: Block out the entire map region completely
	var region = pathfinding_grid.region
	for x in range(region.position.x, region.end.x):
		for y in range(region.position.y, region.end.y):
			pathfinding_grid.set_point_solid(Vector2i(x, y), true)
			
	# STEP 2: Unblock ONLY your specifically painted path cells
	for cell in tilemap_layer.get_used_cells():
		pathfinding_grid.set_point_solid(cell, false) # false means walkable!
			
	print("Moving guest")
	_move_guest()

func _move_guest()->void:
	if not destination or not destination.navi_target:
		print("ERROR: Destination or navi_target is null!")
		return
		
	var start_pos: Vector2 = global_position
	var end_pos: Vector2 = destination.navi_target.global_position
	
	print("--- Pathfinding Debug ---")
	print("Start Global Position: ", start_pos)
	print("End Global Position: ", end_pos)
	
	# Correct way to find map coordinates using your TileMapLayer
	var start_cell: Vector2i = tilemap_layer.local_to_map(start_pos)
	var end_cell: Vector2i = tilemap_layer.local_to_map(end_pos)
	
	print("Start Map Grid Cell: ", start_cell)
	print("End Map Grid Cell: ", end_cell)
	
	# Generate the point path using absolute global positions
	path_to_destination = pathfinding_grid.get_point_path(start_cell, end_cell)
	print("Path points found: ", path_to_destination.size())
	
	# Visual Line2D debug drawing configuration
	if debug_pathfind_line:
		debug_pathfind_line.clear_points()
		for point in path_to_destination:
			# Offset point coordinates to draw the path line directly in the center of the tiles
			var centered_point = point + Vector2(TILE_SIZE / 2.0, TILE_SIZE / 2.0)
			# Draw point relative to Line2D local space
			debug_pathfind_line.add_point(debug_pathfind_line.to_local(centered_point))

	if path_to_destination.size() > 1:
		print("Path calculation successful!")
		path_to_destination.remove_at(0) # Strip current starting tile point
		var go_to_pos: Vector2 = path_to_destination[0] + Vector2(TILE_SIZE/2.0, TILE_SIZE/2.0)

		if go_to_pos.x != global_position.x:
			global_position = go_to_pos
