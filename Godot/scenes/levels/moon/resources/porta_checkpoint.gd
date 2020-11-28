extends Area2D

export var checkpoint_number: int = 1
onready var global = get_node("/root/Global")

func _ready() -> void:
    $Red.visible = global.on_checkpoint != checkpoint_number
    $Green.visible = global.on_checkpoint == checkpoint_number

func _on_PortaPotty_body_exited(body: Node) -> void:
    if body.name == "Player" and global.on_checkpoint < checkpoint_number:
        $Red.visible = false
        $Green.visible = true
        $AnimationPlayer.play("squish")
        global.on_checkpoint = checkpoint_number
