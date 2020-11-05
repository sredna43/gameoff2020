# Jump state, jumps and immediately goes into air state

extends PlayerState

func run(player: KinematicBody2D):
    if player.state_machine.previous_state_tag == "run":
        player.vy = -player.run_jump_power
    else:
        player.vy = -player.jump_power
    player.move()
    return "air"

