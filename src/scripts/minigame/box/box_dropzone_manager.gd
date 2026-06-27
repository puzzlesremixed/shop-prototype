class_name DropZoneManager

extends Node2D

@export var visual_guide_container: Node2D

func _ready() -> void:
	if visual_guide_container == null:
		push_warning("DropZone Manager: No visual guide container assigned!")
		return
		
	var visual_targets: Array[ShopItem.ItemType] = visual_guide_container.targets

	for child in get_children():
		var dropzone := child as Area2D
		if dropzone:
			var idx: int = dropzone.get_index()
			dropzone.acceptable = visual_targets[idx]

func is_complete() -> bool:
	for child in get_children():
		var dropzone := child as Area2D
		if dropzone:
			if !dropzone.is_occupied:
				return false
			
	return true
