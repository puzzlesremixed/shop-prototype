extends Node

#region Settings

var is_game_pausable: bool = false
var game_paused: bool = false

#region

#region Core Scene Variables

var current_scene:Node = null
var Music
var SFX

var Scene:Node

var UI:Node
var Transition
var App:Node

#endregion


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# make sure the script is always running even if scene tree is paused  
	process_mode = PROCESS_MODE_ALWAYS
	App = get_tree().root.get_node('App')
	if(App):
		Scene = App.get_child(0)
		UI = App.get_child(1)

	#SceneManager.change_scene("LogoSplash")

func _notification(what: int) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_menu") and is_game_pausable):
		game_paused = !game_paused
		
func set_paused(status: bool):
	get_tree().paused = status
	current_scene.set_process(!status)
	
func quit():
	get_tree().quit()
