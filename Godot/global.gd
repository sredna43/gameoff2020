extends Node

### Game variables ###

var levels: Array = [
	"res://scenes/levels/test_level/TestLevel.tscn"
   ]

var completed_levels: Array = []

var current_level_path: String = "" setget ,_get_current_level_path

### Player variables ###

# Health and ammo
var max_health: int = 5
var max_ammo: int = 100
var starting_ammo: int = 20
var health
var ammo


### Helper functions ###

func goto_scene(path: String) -> void:
	call_deferred("_deffered_goto_scene", path)
	
func _deffered_goto_scene(path: String) -> void:
	current_level_path = path
	print(path)
	var packed_scene = ResourceLoader.load(path)
	var instanced_scene = packed_scene.instance()
	
	get_tree().get_root().add_child(instanced_scene)
	get_tree().set_current_scene(instanced_scene)

func _get_current_level_path() -> String:
	return current_level_path
	
func restart_level() -> void:
	goto_scene(current_level_path)
	
func win_game() -> void:
	print("Winner!")
