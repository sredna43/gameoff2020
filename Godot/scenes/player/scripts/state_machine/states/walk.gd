# Walk state

extends PlayerState

func run(player: KinematicBody2D) -> String:
    if player.horizontal_input != 0:
        player.vx = player.horizontal_input * player.walk_speed
    player.move()
    
  # Return the next state
  if Input.is_action_pressed("player_run"):
		return "run"
  if player.jumping:
      return "jump"
  if player.horizontal_input == 0:
      return "idle"
  return ""
