# This script controls the movement of the player as well as serves as the
# single source of truth for the player's state in the game

extends KinematicBody2D
class_name Player

# Signals
signal shoot
signal restart_level(checkpoint)

# Global Variables
onready var global: Node = get_node("/root/Global")

# Player Movement (Variables)
export var walk_speed: float = 400
export var run_speed: float = 550
export var walk_accel: float = 55
export var run_accel: float = 30
export var friction: float = 0.2
export var air_accel: float = 30
export var gravity: float = 40
export var terminal_velocity: float = 800
export var jump_power: float = 700
export var run_jump_power: float = 750
export var air_resistance: float = 0.05
var velocity: Vector2 = Vector2.ZERO
var vx: float = 0 setget _set_vx, _get_vx
var vy: float = 0 setget _set_vy, _get_vy
var direction: int = 1

# Input (Variables)
var horizontal_input: int = 0
var vertical_input: int = 0

# Timers
onready var jump_timer: Timer = $Timers/JumpTimer
onready var floor_timer: Timer = $Timers/GroundTimer
onready var shoot_timer: Timer = $Timers/ShootTimer
var grounded: bool = false setget , _get_grounded
var jumping: bool = false setget , _get_jumping

# State Machine (Variables)
onready var state_machine: PlayerFSM = $States
var can_double_jump: bool = true


# Core functions 

func _ready() -> void:
    state_machine.init(self)
    global.health = global.max_health
    global.ammo = global.starting_ammo
    
func _physics_process(_delta: float) -> void:
    _update_inputs()
    state_machine.run()
    if position.y > 1000:
        emit_signal("restart_level", 0)

func move():
    update_look_direction()
    velocity = move_and_slide(velocity, Vector2.UP)
    
func _update_inputs() -> void:   
    horizontal_input = (
        int(Input.is_action_pressed("player_right"))
        - int(Input.is_action_pressed("player_left")))
    vertical_input = (
        int(Input.is_action_pressed("player_jump"))
        - int(Input.is_action_pressed("player_down")))
    direction = horizontal_input if horizontal_input else direction
    # Jump
    if Input.is_action_just_pressed("player_jump"):
        jump_timer.start()
        if state_machine.active_state.tag != "air":
            can_double_jump = true
    # Shoot
    if Input.is_action_pressed("player_shoot") and shoot_timer.is_stopped() and global.ammo:
        global.ammo = clamp(global.ammo-1, 0, global.max_ammo)
        emit_signal("shoot", direction)
        shoot_timer.start()
    if is_on_floor():
        velocity.y = 0
        floor_timer.start()

func apply_gravity():
    if velocity.y <= terminal_velocity:
        velocity.y += gravity
        
# Animations and looks

func update_look_direction():
    if direction == -1:
        pass
    if direction == 1:
        pass
    if velocity.x and state_machine.active_state.tag in ["walk", "run"]:
        if direction != velocity.x/abs(velocity.x):
            # print("kick turn", direction)
            pass


# Setters and Getters

func _set_vx(val:float) -> void:
    velocity.x = val
    vx = val
    
func _get_vx() -> float:
    vx = velocity.x
    return vx
    
func _set_vy(val:float) -> void:
    velocity.y = val
    vy = val
    
func _get_vy() -> float:
    vy = velocity.y
    return vy
    
func _get_grounded() -> bool:
    grounded = not floor_timer.is_stopped()
    return grounded
    
func _get_jumping() -> bool:
    jumping = not jump_timer.is_stopped()    
    return jumping
    
func add_ammo(amount: int) -> void:
    global.ammo = clamp(global.ammo + amount, 0, global.max_ammo)

func add_health(amount: int) -> void:
    global.health = clamp(global.health + amount, 0, global.max_health)

    print("added " + str(amount) + " health to player, total health = " + str(global.health))
