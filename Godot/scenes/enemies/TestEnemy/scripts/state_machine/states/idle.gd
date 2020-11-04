# Idle state for enemy

extends EnemyState

func run(enemy: KinematicBody2D) -> String:
    enemy.vx = 0
    enemy.vy = 0
    enemy.apply_gravity()
    enemy.move()
    
    if not enemy.idle:
        return "walk"
    if not enemy.is_on_floor():
        return "air"
    return ""
