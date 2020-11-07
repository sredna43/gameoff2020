extends Control

onready var ammo_label = $AmmoLabel
onready var health_label = $HealthLabel
onready var oxygen_bar = $OxygenBar

onready var global: Node = get_node("/root/Global")

func _physics_process(delta: float) -> void:
    ammo_label.text = "ammo: " + str(global.ammo)
    health_label.text = "health: " + str(global.health)
