extends PlayerState

#Override run function
func run(player: KinematicBody2D) -> String:
    if player.horizontal_input != 0:
        return "walk"
    return ""