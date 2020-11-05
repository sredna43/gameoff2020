# Player state machine, handles changing states and running states
# Brains behind the controller.gd

extends Node2D
class_name PlayerFSM

var states: Dictionary = {}
var active_state: PlayerState
var previous_state_tag: String = ""
var player: KinematicBody2D

# Initialize states dictionary
func init_states() -> void:
    for state in get_children():
        if state.tag:
            states[state.tag] = state

func init(p: KinematicBody2D) -> void:
    player = p
    init_states()
    active_state = states.idle
    active_state.enter(player)
    
func run() -> void:
    var next_state_tag
    next_state_tag = active_state.run(player)
    if next_state_tag:
        change_state(next_state_tag)

#Takes in string, gets the state from dict. with corresponding tag,
#if there is a state in the dictionary set the previous state to current state 
#(active state)
#exit the active state
#set active state to next state
#enter the active state
func change_state(next_state_tag: String) -> void:
    var next_state = states.get(next_state_tag)
    print(next_state_tag)
    if next_state:
        previous_state_tag = active_state.tag
        active_state.exit(player)
        active_state = next_state
        active_state.enter(player)
