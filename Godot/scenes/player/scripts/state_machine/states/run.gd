#Run state

extends PlayerState

func run(player: KinematicBody2D) -> String:
	player.vx += player.horizontal_input * player.run_accel
	player.vx = clamp(player.vx, -player.run_speed, player.run_speed)
	player.apply_gravity()
	player.move()
	
	# Return next state
	if player.horizontal_input == 0:
		return "idle"
	if not player.is_on_floor():
		player.can_double_jump = false
		return "air"
	if Input.is_action_just_released("player_run"):
		return "walk"
	if player.jumping:
		player.can_double_jump = true
		return "jump"
	return ""
