extends Node2D
class_name ShelfRowScene

@onready var shelf: Shelf = $Shelf
@onready var shelf_2: Shelf = $Shelf2
@onready var shelf_3: Shelf = $Shelf3
@onready var shelf_4: Shelf = $Shelf4
@onready var shelf_5: Shelf = $Shelf5
@onready var shelf_6: Shelf = $Shelf6

@onready var shelfs_members: Array[Shelf] = [
	shelf, shelf_2, shelf_3,shelf_4, shelf_5,shelf_6
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
