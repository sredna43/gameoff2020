extends VBoxContainer

onready var progress_bar = $CenterContainer/TextureProgress
onready var global = get_node("/root/Global")

func _physics_process(_delta: float) -> void:
    progress_bar.value = global.time_left_percent
