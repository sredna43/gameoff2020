extends Control

onready var ammo_label = $HBoxContainer/Labels/AmmoLabel
onready var health_label = $HBoxContainer/Labels/HealthLabel
onready var oxygen_bar = $HBoxContainer/OxygenBar

onready var global: Node = get_node("/root/Global")

func _physics_process(_delta: float) -> void:
    ammo_label.text = "ammo: " + str(global.ammo)
    health_label.text = "health: " + str(global.health)
