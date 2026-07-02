extends Area2D

var disabled: bool = false
var is_cleaning: bool = false
var scrub_accumulated: float = 0.0
var scrub_threshold: float = 800.0
var last_mouse_pos: Vector2 = Vector2.ZERO

@onready var sfx_mop_tiles = $SFX_MopTiles

func _ready() -> void:
	last_mouse_pos = get_global_mouse_position()

func _process(_delta: float) -> void:
	if disabled:
		return
	var current_mouse_pos = get_global_mouse_position()
	global_position = current_mouse_pos
	
	if is_cleaning:
		var distance_moved = last_mouse_pos.distance_to(current_mouse_pos)
		scrub_accumulated += distance_moved
		
		if scrub_accumulated >= scrub_threshold:
			_clean_overlapping_areas()
			scrub_accumulated = 0.0
			
	last_mouse_pos = current_mouse_pos

func _input_event(viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if disabled:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_cleaning = true
			if not sfx_mop_tiles.playing:
				sfx_mop_tiles.play(1.2)
			
			scrub_accumulated = 0.0 
			
			viewport.set_input_as_handled()
		else:
			is_cleaning = false
			if sfx_mop_tiles.playing:
				sfx_mop_tiles.stop()
			scrub_accumulated = 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			is_cleaning = false
			scrub_accumulated = 0.0
			if sfx_mop_tiles.playing:
				sfx_mop_tiles.stop()

func _clean_overlapping_areas() -> void:
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		if area.is_in_group("mop_tiles"):
			area.clean(10)