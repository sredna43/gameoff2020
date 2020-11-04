# parent state for all other states to inherit

extends Node2D
class_name PlayerState

export var tag: String = ""

# Runs when the state is initialized (not entered)
func _ready() -> void:
    tag = name.to_lower()

# Function to be called when we enter this state
func enter(_player: KinematicBody2D) -> void:
    pass
    
# Function to be called with each physics process during runtime
func run(_player: KinematicBody2D) -> String:
    return ""
    
# Function to be called as we exit the state
func exit(_player: KinematicBody2D) -> void:
    pass
