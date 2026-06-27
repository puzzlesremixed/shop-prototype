extends Control
@onready var day_label: Label = $Background/TimeLabelCont/DayLabel
@onready var month_label: Label = $Background/TimeLabelCont/MonthLabel
@onready var year_label: Label = $Background/TimeLabelCont/YearLabel
@onready var money_label: Label = $Background/MoneyLabel

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
