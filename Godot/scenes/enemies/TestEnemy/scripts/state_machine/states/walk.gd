#Enemy walk state

extends EnemyState

var starting_direction: int = 1
var starting_pos: Vector2

func enter(enemy: KinematicBody2D) -> void:
    starting_direction = enemy.direction
    starting_pos = enemy.position
    .enter(enemy)
    
func run(enemy: KinematicBody2D) -> String:
    enemy.vx = enemy.walk_speed * starting_direction
    enemy.apply_gravity()
    enemy.move()
    if not enemy.is_on_floor():
        return "air"
    if enemy.idle:
        return "idle"
    if abs(enemy.position.x - starting_pos.x) > enemy.walk_distance:
        return "idle"
    return ""
    
func exit(enemy: KinematicBody2D) -> void:
    enemy.direction = -starting_direction
    enemy.idle_timer.start()
    .exit(enemy)
