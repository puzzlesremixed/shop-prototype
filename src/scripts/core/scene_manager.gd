extends Node


const SCENES: Dictionary[Variant, Variant] = {
	"MainMenu": "uid://bar5sw1m30ff4",
	"Level_1": "uid://tqntagtqf3yr"
}

var current_scene: Node = null

func change_scene(_scene_name: String) -> void:
	if (!SCENES.has(_scene_name)):
		push_error("Scene '%s' not found in SCENES SceneManager dictionary." % _scene_name)
		return
	
	var _scene_path = SCENES[_scene_name]
	var _packed_scene: Resource = load(_scene_path)
	
	if (_packed_scene == null):
		push_error("Failed ot load scene at path: %s" % _scene_name)
		return
	
	var _new_scene = _packed_scene.instantiate()
	
	if (current_scene):
		current_scene.queue_free()
	
	current_scene = _new_scene
	get_tree().root.add_child(current_scene)
	# Global.Scene.add_child(current_scene)
