extends Node2D

onready var animation_player = $AnimationPlayer

func _on_Area2D_body_entered(body: Node) -> void:
    if body.name == "Player":
        animation_player.play("complete")
