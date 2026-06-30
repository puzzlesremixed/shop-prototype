extends Node2D

@onready var shelf_row: ShelfRowScene = $Shelfs/ShelfRow
@onready var shelf_row_2: ShelfRowScene = $Shelfs/ShelfRow2
@onready var shelf_row_3: ShelfRowScene = $Shelfs/ShelfRow3

var shelf_rows: Array[ShelfRowScene] = [
shelf_row, shelf_row_2, shelf_row_3	
]

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
