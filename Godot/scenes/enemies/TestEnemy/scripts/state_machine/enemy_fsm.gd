# Player state machine, handles changing states and running states
# Brains behind the controller.gd

extends Node2D
class_name EnemyFSM

var states: Dictionary = {}
var active_state: EnemyState
var previous_state_tag: String = ""
var enemy: KinematicBody2D

#Initialize states dictionary
func init_states() -> void:
    for state in get_children():
        if state.tag:
            states[state.tag] = state

func init(e: KinematicBody2D) -> void:
    enemy = e
    init_states()
    active_state = states.idle
    active_state.enter(enemy)

func run() -> void:
    var next_state_tag
    next_state_tag = active_state.run(enemy)
    if next_state_tag:
        change_state(next_state_tag)

func change_state(next_state_tag: String) -> void:
    var next_state = states.get(next_state_tag)
    if next_state:
        previous_state_tag = active_state.tag
        active_state.exit(enemy)
        active_state = next_state
        active_state.enter(enemy)
