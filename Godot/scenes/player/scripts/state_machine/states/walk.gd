# Walk state

extends PlayerState

func run(player: KinematicBody2D) -> String:
    player.apply_gravity()
    player.vx = player.horizontal_input * player.walk_speed if player.horizontal_input != 0 else player.vx
    player.move()
    
    # Return the next state
    if not player.is_on_floor():
        return "air"
    if Input.is_action_pressed("player_run"):
        return "run"
    if player.jumping:
        return "jump"
    if player.horizontal_input == 0:
        return "idle"
    return ""
