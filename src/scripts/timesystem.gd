extends Node
class_name Timesystem

signal updated

@export var date_time: DateTime
@export var tick_index : int = 0
#@export var ticks_per_sec_options: Array[int] = [72, 144, 216,  288]
@export var ticks_per_sec_options: Array[int] = [72, 1440, 21600,  288000]

var is_paused: bool = false

var prev_date : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_input()
	
	date_time.add_seconds(delta * ticks_per_sec_options[tick_index])
	if prev_date != date_time.day :
		prev_date = date_time.day 
		updated.emit(date_time)

func handle_input() ->void:
	if Input.is_action_just_pressed("time_speed_up"):
		tick_index += 1
		tick_index = clamp(tick_index, 0, ticks_per_sec_options.size() - 1)
		print("Game speed updated! Current tick index= ", tick_index, ", Tick/s= " , ticks_per_sec_options[tick_index])
	if Input.is_action_just_pressed("time_slow_down"):
		tick_index -= 1
		tick_index = clamp(tick_index, 0, ticks_per_sec_options.size() - 1)
		print("Game speed updated! Current tick index= ", tick_index, ", Tick/s= " , ticks_per_sec_options[tick_index])
