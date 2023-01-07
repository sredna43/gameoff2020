# Walk state

extends PlayerState

func run(player: KinematicBody2D) -> String:
	player.apply_gravity()
	player.vx += player.horizontal_input * player.walk_accel
	player.vx = clamp(player.vx, -player.walk_speed, player.walk_speed)
	player.move()
	
	# Return the next state
	if not player.is_on_floor():
		player.can_double_jump = false
		return "air"
	if Input.is_action_pressed("player_run"):
		return "run"
	if player.jumping:
		player.can_double_jump = true
		return "jump"
	if player.horizontal_input == 0:
		return "idle"
	return ""
