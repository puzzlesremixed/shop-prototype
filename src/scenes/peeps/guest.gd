extends CharacterBody2D
class_name Guest

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var shopping_list: Array[shop_items]
@export var debug_pathfind_line : Line2D
@export var speed: float = 150.0 
@onready var interaction_area: Area2D = $InteractionArea
@onready var browsing_timer: Timer = $BrowsingTimer
@onready var label: Label = $Label

var TILE_SIZE: int = 32
var tilemap_layer: TileMapLayer
var pathfinding_grid : AStarGrid2D = AStarGrid2D.new()
var path_to_destination : Array = []
var target_position : Vector2 = Vector2.ZERO

var destination: Shelf
var shopping_routes: Array[Shelf];
var current_shelf: int  = 0;
var collected_items: Array[shop_items];

var is_moving : bool = false
var last_direction : String = "Down" 

enum State {
	SHOPPING,
	QUEUEING,
	CHECKOUT,
	LEAVING
}

var state: State = State.SHOPPING

func enter_state(new_state: State):
	state = new_state
	
	match state:
		State.SHOPPING:
			destination = shopping_routes[current_shelf]
			_move_guest()
		
		State.QUEUEING:
			velocity = Vector2.ZERO
		# Tell QueueManager we've arrived
		
		State.CHECKOUT:
			pass
			# Wait for player/minigame
		
		State.LEAVING:
			# todo : get guest to exit door and kill themselves	
			pass
			_move_guest()

func _ready() -> void:
	var names_string = ", ".join(shopping_list.map(func(p): return p.name))
	label.text = names_string

	animated_sprite.play("Idle_Down")
	destination = shopping_routes[current_shelf]
	
	if debug_pathfind_line:
		debug_pathfind_line.global_position = Vector2.ZERO
	
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
	pathfind()


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
		_arrived_at_destination()


func _arrived_at_destination():
	match state:
		State.SHOPPING:
			arrived_at_shelf()
		State.LEAVING:
			queue_free()
		State.QUEUEING:
			pass
		State.CHECKOUT:
			pass

func _update_animation(moving_state: String, dir: Vector2) -> void:
	# Keep track of previous direction if character goes idle
	if moving_state == "Walk" and dir != Vector2.ZERO:
		if abs(dir.x) > abs(dir.y):
			last_direction = "Right" if dir.x > 0 else "Left"
		else:
			last_direction = "Down" if dir.y > 0 else "Up"
			
	var anim_name = moving_state + "_" + last_direction
	update_interaction_area()
	if animated_sprite.animation != anim_name:
		animated_sprite.play(anim_name)
		
func update_interaction_area() -> void:
	match last_direction:
		"Up":
			interaction_area.rotation_degrees = 0
		"Right":
			interaction_area.rotation_degrees = 90
		"Down":
			interaction_area.rotation_degrees = 180
		"Left":
			interaction_area.rotation_degrees = -90

func pathfind() -> void:
	if not is_moving:
		return
		
	# Move toward the current target tile center point
	var distance_to_target: float = global_position.distance_to(target_position)
	
	# Check if we have arrived close enough to the target tile center
	if distance_to_target < 2.0:
		global_position = target_position # Snap perfectly to tile center
		_get_next_path_point()
	else:
		# Calculate direction vector and update velocity
		var direction_vector: Vector2 = (target_position - global_position).normalized()
		velocity = direction_vector * speed
		
		# Track and update sprite movement animation state
		_update_animation("Walk", direction_vector)
		move_and_slide()
		
func check_shelf(shelf: Shelf):
	browsing_timer.start()
	var found = shelf.take_requested_items(shopping_list)
		
	for item in found: 
		shopping_list.erase(item)
		var names_string = ", ".join(shopping_list.map(func(p): return p.name))
		label.text = names_string
		collected_items.append(item)
	
func arrived_at_shelf() -> void:

	check_shelf(destination)
	
	if shopping_list.is_empty():
		enter_queue()
		return
	
	current_shelf += 1
	
	if current_shelf >= shopping_routes.size():
		if collected_items.is_empty():
			pass
#			leave_angry()
		else:
			enter_queue()
		return
	
	destination = shopping_routes[current_shelf]
	
	
func enter_queue():
	state = State.QUEUEING
	
#	queue_manager.add_guest(self)

func checkout_finished():
	state = State.LEAVING
#	destination = exit_point
	_move_guest()


func _on_browsing_timer_timeout() -> void:
	_move_guest()
