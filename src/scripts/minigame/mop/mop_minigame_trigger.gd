extends Node2D

const MOP_MINIGAME_SCENE = preload("uid://yrslf4pb5aq7")
var player_in_zone: bool = false
var player_body: CharacterBody2D

@onready var rating_system: RatingSystem = $"../RatingSystem"

func trigger_mop_minigame() -> void:
	if player_body and not player_body.in_minigame:
		if player_body.camera:
			player_body.shift_camera_minigame(Player.MinigameTransitionSide.RIGHT)
		player_body.in_minigame = true
	else:
		print("No player in zone!")
		return

	var mop_minigame_instance = MOP_MINIGAME_SCENE.instantiate()
	
	get_tree().root.add_child(mop_minigame_instance)

	var mop_tile = mop_minigame_instance.get_node("MopTile")

	if mop_tile:
		mop_tile.minigame_finished.connect(_on_mopping_done)

func _on_mopping_done():
	print("mopping done!")
	player_body.in_minigame = false
	player_body.shift_camera_minigame(Player.MinigameTransitionSide.CENTER)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_body = body
		player_in_zone = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_body = null
		player_in_zone = false

func _unhandled_input(event: InputEvent) -> void:
	if player_in_zone and event.is_action_pressed("interact"):
		trigger_mop_minigame()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("guest"):
		var guest = area.owner
		print(guest)
		if not guest.stepped_on_dirt:
			guest.stepped_on_dirt = true
			rating_system.reduce_rating(15)
