# This is the main Game node that controls everything! Woohoo!

extends Node

onready var global = get_node("/root/Global")
onready var _pause_menu = $PauseMenu

var on_level: Node2D

func _ready() -> void:
    on_level = get_node(global.current_level)
    add_child(on_level)

func _unhandled_input(event):
    if event.is_action_pressed("pause_button"):
        var tree = get_tree()
        tree.paused = not tree.paused
        if tree.paused:
            _pause_menu.open()
        else:
            _pause_menu.close()
        get_tree().set_input_as_handled()
