extends Area2D

var is_cleaning: bool = false
var scrub_accumulated: float = 0.0
var scrub_threshold: float = 800.0 # Pixels of movement required to trigger a clean. Adjust to your liking!
var last_mouse_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
    # Initialize the starting position
    last_mouse_pos = get_global_mouse_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    var current_mouse_pos = get_global_mouse_position()
    global_position = current_mouse_pos
    
    if is_cleaning:
        # 1. Calculate how far the mouse moved since the last frame
        var distance_moved = last_mouse_pos.distance_to(current_mouse_pos)
        
        # 2. Add that distance to our total scrubbed distance
        scrub_accumulated += distance_moved
        
        # 3. If they've scrubbed enough distance, trigger the clean!
        if scrub_accumulated >= scrub_threshold:
            _clean_overlapping_areas()
            scrub_accumulated = 0.0 # Reset to require more scrubbing for the next trigger
            
    # Always update the last position at the end of the frame
    last_mouse_pos = current_mouse_pos

func _input_event(viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            is_cleaning = true
            # Set to threshold so it cleans immediately on the first click
            scrub_accumulated = scrub_threshold 
            viewport.set_input_as_handled()
        else:
            # Mouse released; stop cleaning and reset the distance
            is_cleaning = false
            scrub_accumulated = 0.0

func _clean_overlapping_areas() -> void:
    var overlapping_areas = get_overlapping_areas()
    for area in overlapping_areas:
        if area.is_in_group("mop_tiles"):
            area.clean(10)