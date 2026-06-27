extends Node
class_name Timesystem

@export var date_time: DateTime
@export var ticks_per_sec : int = 6
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	date_time.add_seconds(delta * ticks_per_sec)
	print(date_time.get_date_string())
