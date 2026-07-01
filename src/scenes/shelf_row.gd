extends Node2D
class_name ShelfRowScene

@onready var shelf: Shelf = $Shelf
@onready var shelf_2: Shelf = $Shelf2
@onready var shelf_3: Shelf = $Shelf3
@onready var shelf_4: Shelf = $Shelf4
@onready var shelf_5: Shelf = $Shelf5
@onready var shelf_6: Shelf = $Shelf6

@onready var shelfs_members: Array[Shelf] = [
	shelf_6, shelf_5, shelf_4,  shelf_3, shelf_2,shelf,
]
