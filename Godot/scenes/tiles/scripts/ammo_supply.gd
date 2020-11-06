# This is the Ammo Supply drop! It should add some ammunition to the player
extends Area2D
class_name AmmoSupply

export var supply_size: int = 10

func _on_AmmoSupply_body_entered(body: Node) -> void:
    if body is Player:
        body.add_ammo(supply_size)
        queue_free()
