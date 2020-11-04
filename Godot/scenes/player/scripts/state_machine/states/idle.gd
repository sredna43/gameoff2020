extends PlayerState

#Override run function
func run(player: KinematicBody2D) -> String:
    # Stop the player's motion
    player.vx = 0
    player.vy = 0
    player.move()
    
    # Return the next state
    if not player.is_on_floor():
        return "air"
    if player.horizontal_input != 0:
        return "walk"
    if player.jumping:
        return "jump"
    return ""
