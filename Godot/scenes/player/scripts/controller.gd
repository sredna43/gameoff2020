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
export var walk_speed: float = 350
export var run_speed: float = 550
export var walk_accel: float = 50
export var run_accel: float = 50
export var friction: float = 0.4
export var air_accel: float = 40
export var gravity: float = 40
export var terminal_velocity: float = 800
export var jump_power: float = 700
export var run_jump_power: float = 715
export var air_resistance: float = 0.05
var velocity: Vector2 = Vector2.ZERO
var vx: float = 0 setget _set_vx, _get_vx
var vy: float = 0 setget _set_vy, _get_vy
var direction: Vector2 = Vector2(1,0)

# Input (Variables)
var horizontal_input: int = 0
var vertical_input: int = 0
var controller_is_connected: bool = false
var controller_id: int = 0
var shoot_dir: Vector2

# Timers
onready var jump_timer: Timer = $Timers/JumpTimer
onready var floor_timer: Timer = $Timers/GroundTimer
onready var shoot_timer: Timer = $Timers/ShootTimer
onready var fallthrough_timer: Timer = $Timers/FallthroughTimer
var grounded: bool = false setget , _get_grounded
var jumping: bool = false setget , _get_jumping

# State Machine (Variables)
onready var state_machine: PlayerFSM = $States
var can_double_jump: bool = false

# Player info
var can_fall_through: bool = false


# Core functions 

func _ready() -> void:
    state_machine.init(self)
    global.health = global.max_health
    global.ammo = global.starting_ammo
# warning-ignore:return_value_discarded
    Input.connect("joy_connection_changed", self, "_on_controller_connected")
    if Input.get_joy_name(0):
        controller_id = 0
        controller_is_connected = true
        print("Controller connected: " + str(Input.get_joy_name(controller_id)))
    
func _physics_process(_delta: float) -> void:
    _update_inputs()
    
    for i in get_slide_count():
        var collision = get_slide_collision(i)
        can_fall_through = collision.collider.name == "OneWayMoonTiles"

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
        int(Input.is_action_pressed("player_down"))
        - int(Input.is_action_pressed("player_up")))
    direction.x = float(horizontal_input) if horizontal_input else direction.x
    
    # Jump
    if Input.is_action_just_pressed("player_jump"):
        jump_timer.start()
        
    if is_on_floor():
        velocity.y = 0
        floor_timer.start()

    # Shoot
    if Input.is_action_pressed("player_shoot") and shoot_timer.is_stopped() and global.ammo:
        fire()

func apply_gravity():
    if velocity.y <= terminal_velocity:
        velocity.y += gravity
        
func fire() -> void:
    if not global.dev:
        global.ammo = clamp(global.ammo-1, 0, global.max_ammo)
    var ur = Vector2(1,-1).normalized()
    var dr = Vector2(1,1).normalized()
    var ul = Vector2(-1,-1).normalized()
    var dl = Vector2(-1,1).normalized()
    var r = Vector2.RIGHT
    var u = Vector2.UP
    var l = Vector2.LEFT
    var d = Vector2.DOWN
    if not controller_is_connected or Input.is_mouse_button_pressed(BUTTON_LEFT):
        var vector_to_mouse: Vector2 = get_local_mouse_position()
        var x = vector_to_mouse.x
        var y = -vector_to_mouse.y
        if y <= 0.5 * x and y > -0.5 * x: #RIGHT
            shoot_dir = r
        if y > 0.5 * x and y <= 2 * x: #UP-RIGHT
            shoot_dir = ur
        if y > 2 * x and y >= -2 * x: #UP
            shoot_dir = u
        if y < -2 * x and y >= -0.5 * x: #UP-LEFT
            shoot_dir = ul
        if y < -0.5 * x and y >= 0.5 * x: #LEFT
            shoot_dir = l
        if y < 0.5 * x and y >= 2 * x: #DOWN-LEFT
            shoot_dir = dl
        if y < 2 * x and y <= -2 * x: #DOWN
            shoot_dir = d
        if y > -2 * x and y <= -0.5 * x: #DOWN-RIGHT
            shoot_dir = dr
    else:
        shoot_dir = direction
        if horizontal_input > 0: #RIGHT
            if abs(vertical_input) < 0.4:
                shoot_dir = r
            if vertical_input > 0.4:
                shoot_dir = dr
            if vertical_input < -0.4:
                shoot_dir = ur
        if horizontal_input < 0: #LEFT
            if abs(vertical_input) < 0.4:
                shoot_dir = l
            if vertical_input > 0.4:
                shoot_dir = dl
            if vertical_input < -0.4:
                shoot_dir = ul
        if horizontal_input == 0: #UP/DOWN
            if vertical_input > 0.4:
                shoot_dir = d
            if vertical_input < -0.4:
                shoot_dir = u
    emit_signal("shoot", shoot_dir)
    shoot_timer.start()
    
    
# Animations and looks

func update_look_direction():
    if Input.is_mouse_button_pressed(BUTTON_LEFT):
        if shoot_dir.x < 0:
            $root.scale.x = -0.05
            return
        if shoot_dir.x > 0:
            $root.scale.x = 0.05
            return
    $root.scale.x = 0.05 * velocity.x/abs(velocity.x) if velocity.x != 0 else 0.05 * direction.x
    if velocity.x and state_machine.active_state.tag in ["walk", "run"]:
        if direction.x != velocity.x/abs(velocity.x):
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

func _on_controller_connected(device_id, connected):
    if connected:
        controller_is_connected = connected
        controller_id = device_id
        print("Controller connected: " + str(Input.get_joy_name(device_id)))
    else:
        print("It is recommended to use a controller to play this game")

func _on_FallthroughTimer_timeout() -> void:
    collision_mask = 68
