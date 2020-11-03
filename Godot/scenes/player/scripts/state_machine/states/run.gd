#Run state

extends PlayerState

func run(player: KinematicBody2D) -> String:
    if Input.is_action_pressed("player_run"):
        player.vx = player.horizontal_input * player.walk_speed * 1.65 
        player.move()
        return ""
    return "walk"
