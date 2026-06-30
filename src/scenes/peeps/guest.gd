extends CharacterBody2D
class_name Guest

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var shopping_list: Array[shop_items]
@export var debug_pathfind_line : Line2D
@export var speed: float = 150.0 # Adjusted down from 200 for smoother grid movement

var TILE_SIZE: int = 32
var tilemap_layer: TileMapLayer
var destination: Shelf

var pathfinding_grid : AStarGrid2D = AStarGrid2D.new()
var path_to_destination : Array = []
var target_position : Vector2 = Vector2.ZERO
var is_moving : bool = false
var last_direction : String = "Down" # Default memory fallback for idle state


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
		pathfinding_grid.set_point_solid(cell, false)
			
	_move_guest()


func _physics_process(delta: float) -> void:
	if not is_moving:
		return
		
	# Move toward the current target tile center point
	var distance_to_target = global_position.distance_to(target_position)
	
	# Check if we have arrived close enough to the target tile center
	if distance_to_target < 2.0:
		global_position = target_position # Snap perfectly to tile center
		_get_next_path_point()
	else:
		# Calculate direction vector and update velocity
		var direction_vector = (target_position - global_position).normalized()
		velocity = direction_vector * speed
		
		# Track and update sprite movement animation state
		_update_animation("Walk", direction_vector)
		move_and_slide()


func _move_guest() -> void:
	if not destination or not destination.navi_target:
		print("ERROR: Destination or navi_target is null!")
		return
		
	var start_pos: Vector2 = global_position
	var end_pos: Vector2 = destination.navi_target.global_position
	
	var start_cell: Vector2i = tilemap_layer.local_to_map(start_pos)
	var end_cell: Vector2i = tilemap_layer.local_to_map(end_pos)
	
	# Generate the point path using absolute global positions
	path_to_destination = Array(pathfinding_grid.get_point_path(start_cell, end_cell))
	
	# Visual Line2D debug drawing configuration
	if debug_pathfind_line:
		debug_pathfind_line.clear_points()
		for point in path_to_destination:
			var centered_point = point + Vector2(TILE_SIZE / 2.0, TILE_SIZE / 2.0)
			debug_pathfind_line.add_point(debug_pathfind_line.to_local(centered_point))

	# Initialize step-by-step movement processing
	if path_to_destination.size() > 1:
		path_to_destination.remove_at(0) # Strip current starting tile point
		_get_next_path_point()
	else:
		_update_animation("Idle", Vector2.ZERO)


func _get_next_path_point() -> void:
	if path_to_destination.size() > 0:
		# Extract the next path coordinate and apply center tile positioning offsets
		var next_grid_pos: Vector2 = path_to_destination.pop_front()
		target_position = next_grid_pos + Vector2(TILE_SIZE / 2.0, TILE_SIZE / 2.0)
		is_moving = true
	else:
		# Arrived at the final destination shelf
		is_moving = false
		velocity = Vector2.ZERO
		_update_animation("Idle", Vector2.ZERO)


func _update_animation(state: String, dir: Vector2) -> void:
	# Keep track of previous direction if character goes idle
	if state == "Walk" and dir != Vector2.ZERO:
		if abs(dir.x) > abs(dir.y):
			last_direction = "Right" if dir.x > 0 else "Left"
		else:
			last_direction = "Down" if dir.y > 0 else "Up"
			
	# Construct string matches: "Walk_Left", "Idle_Up", etc.
	var anim_name = state + "_" + last_direction
	
	if animated_sprite.animation != anim_name:
		animated_sprite.play(anim_name)
