# Anytime the player is in the air, both on the way up and the way down

extends PlayerState

var max_speed: float = 0

func enter(player: KinematicBody2D):
    max_speed = abs(player.vx) if abs(player.vx) > 0 else player.walk_speed
    .enter(player)
    
func run(player: KinematicBody2D):
    if abs(player.horizontal_input) > 0 and abs(player.vx + player.horizontal_input) < max_speed:
        player.vx += player.horizontal_input * player.air_accel
    player.vx = clamp(player.vx, -max_speed, max_speed)
    if abs(player.vx) > 0 and player.horizontal_input == 0:
        player.vx = lerp(player.vx, 0, player.air_resistance)
    player.apply_gravity()
    player.move()
    
    # Return next state
    if player.is_on_floor():
        return "idle" if player.horizontal_input == 0 else "walk"
    if player.grounded and player.jumping:
        return "jump"
    return ""
