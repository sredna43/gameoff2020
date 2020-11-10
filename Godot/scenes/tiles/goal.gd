extends Area2D

onready var global = get_node("/root/Global")

func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		global.win_game()
