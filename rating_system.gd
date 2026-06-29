extends Node
class_name RatingSystem

signal rating_increased;
signal rating_decreased;

var current_rating : int = 0 ;

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		add_rating(100)
	if Input.is_action_just_pressed("ui_down"):
		reduce_rating(100)

func add_rating(amount: int):
	if (current_rating < 999):
		var new_rating = clamp(current_rating+amount, 0, 999)
		current_rating = new_rating
		rating_increased.emit(current_rating)
	
func reduce_rating(amount: int):
	if (current_rating > 0):
		var new_rating = clamp(current_rating-amount, 0, 999)
		current_rating = new_rating
		rating_decreased.emit(current_rating)
