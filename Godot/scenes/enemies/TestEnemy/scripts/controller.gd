# Controls the movement of the TestEnemy

extends KinematicBody2D
class_name TestEnemy

export var walk_speed: float = 350
export var gravity: float = 40
export var terminal_velocity: float = 700

onready var attack_timer: Timer = $Timers/AttackTimer

onready var state_machine: EnemyFSM = $States

func _ready():
    state_machine.init(self)


