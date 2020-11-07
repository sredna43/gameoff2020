# Basic controller for all of the levels to use

extends Node2D
class_name Level

onready var global = get_node("/root/Global")

func _ready() -> void:
    var _restart_signal = get_node("Player").connect("restart_level", self, "_restart")
    
func _restart(checkpoint: int) -> void:
    if checkpoint == 0:
        global.restart_level()
    queue_free()
