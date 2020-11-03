# This script controls the movement of the player as well as serves as the
# single source of truth for the player's state in the game

extends KinematicBody2D
class_name Player

# Player Movement
export var walk_speed: float = 250
export var run_speed: float = 350
export var gravity: float = 40
export var jump_power: float = 400
var velocity: Vector2 = Vector2.ZERO
var vx: float = 0 setget _set_vx, _get_vx
var vy: float = 0 setget _set_vy, _get_vy

# Inputs
var horizontal_input: int = 0
var vertical_input: int = 0

# State Machine
onready var state_machine: PlayerFSM = $States


# Core functions

func _ready() -> void:
    state_machine.init(self)
    
func _physics_process(delta: float) -> void:
    pass
    
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
