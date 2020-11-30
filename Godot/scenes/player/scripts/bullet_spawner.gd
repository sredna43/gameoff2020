# Controls the spawner for the bullets that the player can fire

extends Node2D

var ur = Vector2(1,-1).normalized()
var dr = Vector2(1,1).normalized()
var ul = Vector2(-1,-1).normalized()
var dl = Vector2(-1,1).normalized()
var r = Vector2.RIGHT
var u = Vector2.UP
var l = Vector2.LEFT
var d = Vector2.DOWN

var bullet = preload("res://scenes/player/weapon/Bullet.tscn")
onready var location = get_parent()

func set_init_rotation(nb: KinematicBody2D, dir: Vector2):
    if dir == r:
        nb.rotation_degrees = 0
    if dir == ur:
        nb.rotation_degrees = -45
    if dir == dr:
        nb.rotation_degrees = 45
    if dir == l:
        nb.rotation_degrees = 180
    if dir == ul:
        nb.rotation_degrees = -135
    if dir == dl:
        nb.rotation_degrees = 135
    if dir == u:
        nb.rotation_degrees = -90
    if dir == d:
        nb.rotation_degrees = 90

func fire(direction: Vector2) -> void:
    var new_bullet = bullet.instance()
    new_bullet.direction = direction
    set_init_rotation(new_bullet, direction)
    add_child(new_bullet)
