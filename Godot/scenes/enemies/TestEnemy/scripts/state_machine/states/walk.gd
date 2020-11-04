#Enemy walk state

extends EnemyState

var walk_speed

func _physics_process(delta):
    var direction = ($Player. position - position).normalize()
    var motion = direction * walk_speed * delta 
    position += motion
