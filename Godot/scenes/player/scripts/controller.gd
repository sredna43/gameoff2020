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
export var terminal_velocity: float = 900
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
onready var hit_cooldown_timer: Timer = $Timers/HitCooldownTimer
onready var fallthrough_timer: Timer = $Timers/FallthroughTimer
var grounded: bool = false setget , _get_grounded
var jumping: bool = false setget , _get_jumping

# State Machine (Variables)
onready var state_machine: PlayerFSM = $States
var can_double_jump: bool = false

# Player info
var can_fall_through: bool = false
var on_vertical_platform: bool = false

# Animation
onready var animation_player: AnimationPlayer = $root/AnimationPlayer

# Shooting
onready var gun: Sprite = $root/hip/torso/bicep_r
onready var bullet_spawn: Position2D = $BulletSpawnerLocation
var ur = Vector2(1,-1).normalized()
var dr = Vector2(1,1).normalized()
var ul = Vector2(-1,-1).normalized()
var dl = Vector2(-1,1).normalized()
var r = Vector2.RIGHT
var u = Vector2.UP
var l = Vector2.LEFT
var d = Vector2.DOWN

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
    if global.dev:
        $debug/message.text = "State: " + state_machine.active_state.tag
    else:
        $debug/message.text = ""
    _update_inputs()
    if get_slide_count():
        for i in get_slide_count():
            var collision = get_slide_collision(i)
            if collision.collider:
                can_fall_through = collision.collider.name == "OneWayMoonTiles"
                on_vertical_platform = collision.collider.name.begins_with("VerticalPlatform")
                if collision.collider.name in global.things_that_kill_you and not hit_cooldown_timer.time_left > 0:
                    hit(collision.collider.name)
    else:
        can_fall_through = false
        on_vertical_platform = false

    state_machine.run()
    if position.y > 2000:
        die("fallout")

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
    if velocity.y <= terminal_velocity and not on_vertical_platform:
        velocity.y += gravity
        
        
func fire() -> void:
    if global.game_state != global.GAME_STATES.PLAYING:
        return
    if not global.dev:
        global.ammo = clamp(global.ammo-1, 0, global.max_ammo)
    if not controller_is_connected or Input.is_mouse_button_pressed(BUTTON_LEFT):
        var vector_to_mouse: Vector2 = get_local_mouse_position()
        var x = vector_to_mouse.x
        var y = -vector_to_mouse.y
        
        if y <= 0.5 * x and y > -0.5 * x: #RIGHT
            shoot_dir = r
            gun.rotation_degrees = -90
            bullet_spawn.position = Vector2(15, -9)
            
        if y > 0.5 * x and y <= 2 * x: #UP-RIGHT
            shoot_dir = ur
            gun.rotation_degrees = -135
            bullet_spawn.position = Vector2(11, -21)
            
        if y > 2 * x and y >= -2 * x: #UP
            shoot_dir = u
            gun.rotation_degrees = -180
            bullet_spawn.position = Vector2(0, -24)
            
        if y < -2 * x and y >= -0.5 * x: #UP-LEFT
            shoot_dir = ul
            gun.rotation_degrees = -135
            bullet_spawn.position = Vector2(-11, -21)
            
        if y < -0.5 * x and y >= 0.5 * x: #LEFT
            shoot_dir = l
            gun.rotation_degrees = -90
            bullet_spawn.position = Vector2(-15, -9)
            
        if y < 0.5 * x and y >= 2 * x: #DOWN-LEFT
            shoot_dir = dl
            gun.rotation_degrees = -45
            bullet_spawn.position = Vector2(-11, 2)
            
        if y < 2 * x and y <= -2 * x: #DOWN
            shoot_dir = d
            gun.rotation_degrees = 0
            bullet_spawn.position = Vector2(0, 7)
            
        if y > -2 * x and y <= -0.5 * x: #DOWN-RIGHT
            shoot_dir = dr
            gun.rotation_degrees = -45
            bullet_spawn.position = Vector2(11, 2)
    else:
        shoot_dir = direction
        if horizontal_input > 0:
            if abs(vertical_input) < 0.4: #RIGHT
                shoot_dir = r
                gun.rotation_degrees = -90
                bullet_spawn.position = Vector2(15, -9)
                
            if vertical_input > 0.4: #DOWN-RIGHT
                shoot_dir = dr
                gun.rotation_degrees = -45
                bullet_spawn.position = Vector2(11, 2)
                
            if vertical_input < -0.4: #UP-RIGHT
                shoot_dir = ur
                gun.rotation_degrees = -135
                bullet_spawn.position = Vector2(11, -21)
                
        if horizontal_input < 0:
            if abs(vertical_input) < 0.4: #LEFT
                shoot_dir = l
                gun.rotation_degrees = -90
                bullet_spawn.position = Vector2(-15, -9)
                
            if vertical_input > 0.4: #DOWN-LEFT
                shoot_dir = dl
                gun.rotation_degrees = -45
                bullet_spawn.position = Vector2(-11, 2)
                
            if vertical_input < -0.4: #UP-LEFT
                shoot_dir = ul
                gun.rotation_degrees = -135
                bullet_spawn.position = Vector2(-11, -21)
                
        if horizontal_input == 0:
            if vertical_input > 0.4: #DOWN
                shoot_dir = d
                gun.rotation_degrees = 0
                bullet_spawn.position = Vector2(0, 7)
                
            if vertical_input < -0.4: #UP
                shoot_dir = u
                gun.rotation_degrees = -180
                bullet_spawn.position = Vector2(0, -24)
                
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
    if shoot_dir.y == 0:
        gun.rotation_degrees = -90
    if velocity.x and state_machine.active_state.tag in ["walk", "run"]:
        if direction.x != velocity.x/abs(velocity.x):
            pass
            
func play_animation(animation: String) -> void:
    if animation_player.current_animation == animation:
        return
    animation_player.play(animation)
            

# Get hit and die
            
func hit(_by: String) -> void:
    hit_cooldown_timer.start()
    update_health(-1)
    if global.health == 0:
        die(_by)
            
func die(_reason: String) -> void:
    emit_signal("restart_level")


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

func update_health(amount: int) -> void:
    global.health = clamp(global.health + amount, 0, global.max_health)

func _on_controller_connected(device_id, connected):
    if connected:
        controller_is_connected = connected
        controller_id = device_id
        print("Controller connected: " + str(Input.get_joy_name(device_id)))
    else:
        print("It is recommended to use a controller to play this game")

func _on_FallthroughTimer_timeout() -> void:
    collision_mask = 68
