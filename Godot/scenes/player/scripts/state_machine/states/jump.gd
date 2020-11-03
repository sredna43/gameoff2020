# Jump state, jumps and immediately goes into air state

extends PlayerState

func run(player: KinematicBody2D):
    player.vy = -player.jump_power
    player.move()
    return "air"
