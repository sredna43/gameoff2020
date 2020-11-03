# This script controls the movement of the player as well as serves as the
# single source of truth for the player's state in the game

extends KinematicBody2D
class_name Player

# Player Movement (Variables)
export var walk_speed: float = 250
export var run_speed: float = 350
export var gravity: float = 40
export var jump_power: float = 400
var velocity: Vector2 = Vector2.ZERO
var vx: float = 0 setget _set_vx, _get_vx
var vy: float = 0 setget _set_vy, _get_vy

# Input (Variables)
var horizontal_input: int = 0
var vertical_input: int = 0


# State Machine (Variables)
onready var state_machine: PlayerFSM = $States


# Core functions 

func _ready() -> void:
    state_machine.init(self)
    
func _physics_process(delta: float) -> void:
    _update_inputs()
    state_machine.run()

func move():
    velocity = move_and_slide(velocity, Vector2.UP)
    
func _update_inputs() -> void:
    horizontal_input = (
        int(Input.is_action_pressed("player_right"))
        - int(Input.is_action_pressed("player_left"))
    )

func apply_gravity():
    pass


# Setters and Getters

func _set_vx(val:float) -> void:
    velocity.x = val
    vx = val
    
func _get_vx() -> float:
    return vx
    
func _set_vy(val:float) -> void:
    velocity.y = val
    vy = val
    
func _get_vy() -> float:
    return vy
