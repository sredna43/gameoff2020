# This is the main Game node that controls everything! Woohoo!

extends Node

onready var global: Node = get_node("/root/Global")
onready var _pause_menu = $PauseMenu

func _ready() -> void:
	global.current_level_path = global.levels[0]
	global.goto_scene(global.current_level_path)

func _unhandled_input(event):
	if event.is_action_pressed("pause_button"):
		var tree = get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			_pause_menu.open()
		else:
			_pause_menu.close()
		get_tree().set_input_as_handled()
