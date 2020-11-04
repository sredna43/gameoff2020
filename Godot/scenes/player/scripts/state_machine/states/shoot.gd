# Shoot state

extends PlayerState

func run(player: KinematicBody2D):
    var next_state = str(player.state_machine.previous_state)
    player.emit_signal("shoot", self)
    return next_state
