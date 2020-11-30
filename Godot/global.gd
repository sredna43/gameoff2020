# Holds global functions and variables, auto-load singleton.

extends Node

### Game variables ###

var dev: bool = true

# Worlds
var worlds: Dictionary = {
    "Test": {"Level1": "res://scenes/levels/test_level/TestLevel.tscn"},
    "Moon": {"Level1": "res://scenes/levels/moon/Level1.tscn"}
   }
var completed_levels: Array = []
var current_level_path: String = "" setget ,_get_current_level_path
var death_by_world: Dictionary = {
    "Moon": ["Spikes"]
   }
var things_that_kill_you: Array

# Level timer
var time_left_percent: int = -1
var time_left_seconds: int = 0
var is_restart = false

# Level checkpoints
var on_checkpoint: int = 0


### Player variables ###

# Health and ammo
var max_health: int = 5
var max_ammo: int = 100
var starting_ammo: int = 20
var health
var ammo
var bullet_speed: int = 1250


### Helper functions ###

# Set the scene stuff
func goto_scene(path: String) -> void:
    call_deferred("_deffered_goto_scene", path)
    
func _deffered_goto_scene(path: String) -> void:
    current_level_path = path
    print_debug("Loaded level: " + path)
    var packed_scene = ResourceLoader.load(path)
    var instanced_scene = packed_scene.instance()
    
    get_tree().get_root().add_child(instanced_scene)
    get_tree().set_current_scene(instanced_scene)

# Setters and getters
func _get_current_level_path() -> String:
    return current_level_path
    
func restart_level() -> void:
    # What to do when the player reaches the end, may be moved
    goto_scene(current_level_path)
    
func win_game() -> void:
    pass
