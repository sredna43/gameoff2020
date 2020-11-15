# Main control of the in-game HUD

extends Control

onready var ammo_label = $Labels/AmmoLabel
onready var health_label = $Labels/HealthLabel
onready var oxygen_bar = $OxygenBar

onready var global: Node = get_node("/root/Global")

func _physics_process(_delta: float) -> void:
    ammo_label.text = "ammo: " + str(global.ammo)
    health_label.text = "health: " + str(global.health)
