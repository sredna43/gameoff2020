# Controls the movement of the TestEnemy

extends KinematicBody2D
class_name TestEnemy

# Speed variables
export var walk_speed: float = 350
export var gravity: float = 40
export var terminal_velocity: float = 700

# Velocity variables
var velocity: Vector2 = Vector2.ZERO
var vx: float = 0 setget _set_vx, _get_vx
var vy: float = 0 setget _set_vy, _get_vy

# Timers
onready var attack_timer: Timer = $Timers/AttackTimer

# State Machine
onready var state_machine: EnemyFSM = $States

# Core functions

func _ready():
    state_machine.init(self)

func _physics_process(delta: float) -> void:
    state_machine.run()
    
func apply_gravity():
    if velocity.y <= terminal_velocity:
        velocity.y += gravity
        
func move():
    velocity = move_and_slide(velocity, Vector2.UP)

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
