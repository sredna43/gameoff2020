#Run state

extends PlayerState

func run(player: KinematicBody2D) -> String:
    player.vx = player.horizontal_input * player.run_speed
    player.apply_gravity()
    player.move()
    
    # Return next state
    if not player.is_on_floor():
        return "air"
    if Input.is_action_just_released("player_run"):
        return "walk"
    if player.jumping:
        return "jump"
    return ""
