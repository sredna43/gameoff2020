#Run state

extends PlayerState

func run(player: KinematicBody2D) -> String:
    player.vx = player.horizontal_input * player.run_speed
    player.move()
    if Input.is_action_just_released("player_run"):
        return "walk"
    if player.jumping:
        return "jump"
    return ""
