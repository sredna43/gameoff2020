# Controls the movement of the TestEnemy

extends KinematicBody2D
class_name Enemy

# Speed variables
export var walk_speed: float = 150
export var gravity: float = 40
export var terminal_velocity: float = 700

# Velocity variables
var velocity: Vector2 = Vector2.ZERO
var vx: float = 0 setget _set_vx, _get_vx
var vy: float = 0 setget _set_vy, _get_vy
var direction: int = -1

# Walk distance
export var walk_distance: int = 200


# Timers
onready var attack_timer: Timer = $Timers/AttackTimer
onready var idle_timer: Timer = $Timers/IdleTimer
onready var ground_timer: Timer = $Timers/GroundTimer
var attacking: bool = false setget ,_get_attacking
var idle: bool = false setget ,_get_idle
var grounded: bool = false setget ,_get_grounded

# State Machine
onready var state_machine: EnemyFSM = $States

# Core functions

func _ready():
    state_machine.init(self)
    idle_timer.start()

func _physics_process(_delta: float) -> void:
    state_machine.run()
    
func apply_gravity():
    if velocity.y <= terminal_velocity:
        velocity.y += gravity
        
func move():
    if is_on_floor():
        ground_timer.start()
    velocity = move_and_slide(velocity, Vector2.UP)
    
# Hit by a bullet
func hit():
    print("Enemy has been hit!")

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
    
func _get_attacking() -> bool:
    return not attack_timer.is_stopped()
    
func _get_idle() -> bool:
    return not idle_timer.is_stopped()
    
func _get_grounded() -> bool:
    return not ground_timer.is_stopped()
