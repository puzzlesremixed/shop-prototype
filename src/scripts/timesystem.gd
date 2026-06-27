extends Node
class_name Timesystem

signal updated

@export var date_time: DateTime
@export var ticks_per_sec : int = 6

var prev_date : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	date_time.add_seconds(delta * ticks_per_sec)
	
	if prev_date != date_time.day :
		prev_date = date_time.day 
		updated.emit(date_time)
