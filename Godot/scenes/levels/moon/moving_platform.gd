# Controls the Moving platforms used in the moon world.

extends KinematicBody2D

export var relative_destination: Vector2 = Vector2(384, 0)
export var speed: float = 64
onready var init_pos: Vector2 = position
onready var target: Vector2 = init_pos + relative_destination
onready var direction: Vector2 = init_pos.direction_to(target)
var velocity: Vector2
var state: int

enum States {TO_TARGET, TO_INIT_POS}

func _ready() -> void:
    state = States.TO_TARGET
    
func _physics_process(_delta: float) -> void:
    if state == States.TO_TARGET:
        direction = position.direction_to(target)
        if position.distance_to(target) > speed:
            velocity = speed * direction
        elif position.distance_to(target) < 2:
            state = States.TO_INIT_POS
    if state == States.TO_INIT_POS:
        direction = position.direction_to(init_pos)
        if position.distance_to(init_pos) > speed:
            velocity = speed * direction
        elif position.distance_to(init_pos) < 2:
            state = States.TO_TARGET
    velocity = move_and_slide(velocity)
