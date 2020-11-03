# This script controls the movement of the player as well as serves as the
# single source of truth for the player's state in the game

extends KinematicBody2D
class_name Player

# Player Movement (Variables)
export var walk_speed: float = 250
export var run_speed: float = 350
export var air_speed: float = 300
export var gravity: float = 40
export var terminal_velocity: float = 700
export var jump_power: float = 400
export var air_resistance: float = 0.05
var velocity: Vector2 = Vector2.ZERO
var vx: float = 0 setget _set_vx, _get_vx
var vy: float = 0 setget _set_vy, _get_vy

# Input (Variables)
var horizontal_input: int = 0
var vertical_input: int = 0

# Timers
onready var jump_timer: Timer = $Timers/JumpTimer
onready var floor_timer: Timer = $Timers/GroundTimer
var grounded: bool = false setget , _get_grounded
var jumping: bool = false setget , _get_jumping

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
        - int(Input.is_action_pressed("player_left")))
    vertical_input = (
        int(Input.is_action_pressed("player_jump"))
        - int(Input.is_action_pressed("player_down")))
        
    if Input.is_action_just_pressed("player_jump"):
        jump_timer.start()
    if is_on_floor():
        velocity.y = 0
        floor_timer.start()

func apply_gravity():
    if velocity.y <= terminal_velocity:
        velocity.y += gravity


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
    
func _get_grounded() -> bool:
    grounded = not floor_timer.is_stopped()
    return grounded
    
func _get_jumping() -> bool:
    jumping = not jump_timer.is_stopped()    
    return jumping
