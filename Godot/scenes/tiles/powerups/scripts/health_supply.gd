extends Area2D
class_name HealthSupply

export var supply_size: int = 5

func _on_HealthSupply_body_entered(body: Node) -> void:
    if body is Player:
        body.add_health(supply_size)
        queue_free()
