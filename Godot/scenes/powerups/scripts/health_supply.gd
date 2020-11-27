extends Area2D
class_name HealthSupply

export var supply_size: int = 2

func _on_HealthSupply_body_entered(body: Node) -> void:
    if body is Player:
        body.update_health(supply_size)
        queue_free()
