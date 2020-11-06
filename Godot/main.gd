# This is the main Game node that controls everything! Woohoo!

extends Node

onready var _pause_menu = $PauseMenu

var levels: Dictionary = {}

func _ready() -> void:
    pass

func _unhandled_input(event):
    if event.is_action_pressed("pause_button"):
        var tree = get_tree()
        tree.paused = not tree.paused
        if tree.paused:
            _pause_menu.open()
        else:
            _pause_menu.close()
        get_tree().set_input_as_handled()
