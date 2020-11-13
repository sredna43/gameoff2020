# Controls the spawner for the bullets that the player can fire

extends Node2D

var bullet = preload("res://scenes/player/weapon/Bullet.tscn")
onready var location = get_parent()

func fire(direction: Vector2) -> void:
	var new_bullet = bullet.instance()
	new_bullet.direction = direction
	add_child(new_bullet)
