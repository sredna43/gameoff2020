# Anytime the player is in the air, both on the way up and the way down

extends PlayerState

func run(player: KinematicBody2D):
    if player.horizontal_input != 0:
        player.vx = player.horizontal_input * player.air_speed
    if abs(player.vx) > 0 and player.horizontal_input == 0:
        player.vx = lerp(player.vx, 0, player.air_resistance)
    player.apply_gravity()
    
    # Return next state
    if player.is_on_floor():
        return "idle" if player.horizontal_input == 0 else "walk"
    if player.grounded and player.jumping:
        return "jump"
    player.move()
    return ""
