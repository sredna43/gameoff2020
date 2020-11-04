# Bullet script, moves the bullet

extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO
var direction: int = 0

func _ready() -> void:
    set_as_toplevel(true)

func _physics_process(_delta: float) -> void:
    if is_on_wall():
        queue_free()
    else:
        velocity.x = 1000 * direction
    velocity = move_and_slide(velocity, Vector2.UP)
