# Bullet script, moves the bullet

extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var initial_rotation: float = 90

onready var global: Node = get_node("/root/Global")

func _ready() -> void:
    set_as_toplevel(true)
    $Sprite.rotation_degrees = initial_rotation
    

func _physics_process(_delta: float) -> void:
    if get_slide_count():
        queue_free()
    else:
        velocity = global.bullet_speed * direction
    velocity = move_and_slide(velocity, Vector2.UP)


func _on_HitBox_body_entered(body: Node) -> void:
    if body is Enemy:
        body.hit()
        queue_free()
