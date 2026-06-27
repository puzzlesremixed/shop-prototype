extends Resource
class_name DateTime

var total_seconds: int = 0

# start date
@export var base_year: int = 2026
var year: int
@export_range(1, 12) var month: int = 1
@export_range(1, 31) var day: int = 1

var hour: int = 0
var minute: int = 0
var second: int = 0

func add_seconds(delta: float) -> void:
	total_seconds += int(delta)
	_update_datetime()

# Convert total_seconds → calendar date
func _update_datetime() -> void:
	var secs := total_seconds

	# time
	second = secs % 60
	secs /= 60

	minute = secs % 60
	secs /= 60

	hour = secs % 24
	var total_days = secs / 24

	# ---- date ----
	year = base_year

	while true:
		var days_in_year = 365 + (1 if _is_leap_year(year) else 0)

		if total_days >= days_in_year:
			total_days -= days_in_year
			year += 1
		else:
			break

	month = 1
	var month_days = _get_month_days(year)

	for days_in_month in month_days:
		if total_days >= days_in_month:
			total_days -= days_in_month
			month += 1
		else:
			break

	day = total_days + 1


func _is_leap_year(y: int) -> bool:
	return (y % 4 == 0 and y % 100 != 0) or (y % 400 == 0)


func _get_month_days(y: int) -> Array[int]:
	return [
		31,
		29 if _is_leap_year(y) else 28,
		31,
		30,
		31,
		30,
		31,
		31,
		30,
		31,
		30,
		31
	]
	
func get_date_string() -> String:
	return "%04d-%02d-%02d %02d:%02d:%02d" % [
		year,
		month,
		day,
		hour,
		minute,
		second
	]