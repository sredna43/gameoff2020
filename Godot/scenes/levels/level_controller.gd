# Basic controller for all of the levels to use

extends Node2D
class_name Level

onready var global = get_node("/root/Global")
onready var o2_timer: Timer = get_node("OxygenTimer")
var initial_time: float

func _ready() -> void:
    var _restart_error = get_node("Player").connect("restart_level", self, "_restart")
    var _o2_timeout_error = o2_timer.connect("timeout", self, "_o2_timeout")
    initial_time = o2_timer.wait_time
    if global.is_restart:
        o2_timer.wait_time = clamp(global.time_left_seconds + 2, 0, initial_time)
    o2_timer.start()
    
func _process(_delta: float) -> void:
    global.time_left_percent = o2_timer.time_left/initial_time * 100
    global.time_left_seconds = o2_timer.time_left
    
func _restart(_checkpoint: int) -> void:
    global.is_restart = true
    global.restart_level()
    queue_free()

func _o2_timeout() -> void:
    print("Time's Up!")
