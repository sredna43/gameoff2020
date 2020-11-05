# Enemy air state

extends EnemyState

func run(enemy: KinematicBody2D) -> String:
    enemy.apply_gravity()
    enemy.move()
    if enemy.is_on_floor() and enemy.idle:
        return "idle"
    return ""
