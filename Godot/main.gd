# This is the main Game node that controls everything! Woohoo!

extends Node

onready var global: Node = get_node("/root/Global")
onready var _pause_menu = $PauseMenu
onready var _main_menu = $MainMenu
onready var _start_button = $MainMenu/Menu/StartButton
var current_world: String = "Moon"
var current_level: String = "Level1"

func _ready() -> void:
    _main_menu.open()
    _start_button.connect("pressed", self, "start_game")
    
func start_game() -> void:
    _main_menu.close()
    global.game_state = global.GAME_STATES.PLAYING
    global.current_level_path = global.worlds[current_world][current_level]
    global.things_that_kill_you = global.death_by_world[current_world]
    global.on_checkpoint = 0
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
