# Jump state, jumps and immediately goes into air state

extends PlayerState

func enter(player: KinematicBody2D):
    if player.can_double_jump:
        .enter(player)
    else:
        player.animation_player.playback_speed = 1.5
        player.animation_player.play("double_jump")

func run(player: KinematicBody2D):
    if player.state_machine.previous_state_tag == "run":
        player.vy = -player.run_jump_power
    else:
        player.vy = -player.jump_power
    player.move()
        
    return "air"

