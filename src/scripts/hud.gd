extends Control
@onready var day_label: Label = $Background/TimeLabelCont/DayLabel
@onready var month_label: Label = $Background/TimeLabelCont/MonthLabel
@onready var year_label: Label = $Background/TimeLabelCont/YearLabel
@onready var money_label: Label = $Background/MoneyLabel

@onready var rating_label_2: Label = $Background/RatingCont/RatingLabel2
@onready var rating_direction: Label = $Background/RatingCont/RatingDirection
@onready var timer: Timer = $Background/RatingCont/Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timesystem_updated(date_time: DateTime) -> void:
	day_label.text = str(date_time.day)
	month_label.text = str(date_time.get_month_label())
	year_label.text = str(date_time.year)


func _on_money_system_balance_updated(balance:  int) -> void:
	money_label.text = str("$", balance)


func _on_timer_timeout() -> void:
	rating_direction.text  =""


func _on_rating_system_rating_decreased(value : int) -> void:
	rating_label_2.text = str(value)
	rating_direction.text = str("↓")
	timer.start()

func _on_rating_system_rating_increased(value : int) -> void:
	rating_direction.text = str("↑")
	rating_label_2.text = str(value)
	timer.start()
