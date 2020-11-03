# Walk state

extends PlayerState

func run(player: KinematicBody2D) -> String:
	if player.horizontal_input != 0:
		player.vx = player.horizontal_input * player.walk_speed
	player.move()

	if player.horizontal_input == 0:
		return "idle"

	if Input.is_action_pressed("player_run"):
		return "run"
	return ""
