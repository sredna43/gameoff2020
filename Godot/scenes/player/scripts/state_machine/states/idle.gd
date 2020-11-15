# Controls the idle player state

extends PlayerState

#Override run function
func run(player: KinematicBody2D) -> String:
	# Stop the player's motion
	if player.vx != 0:
		player.vx = lerp(player.vx, 0, player.friction)
	if abs(player.vx) < 1:
		player.vx = 0
	player.vy = 0
	player.apply_gravity()
	player.move()
	
	# Return the next state
	if not player.is_on_floor():
		player.can_double_jump = false
		return "air"
	if player.horizontal_input != 0 and not Input.is_action_pressed("player_aim"):
		return "walk"
	if player.jumping:
		player.can_double_jump = true
		return "jump"
	return ""
