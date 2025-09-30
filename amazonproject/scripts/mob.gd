class_name Enemy
extends CombatEntity


var target: Player
var detection_radius = 200

func _physics_process(delta):
	if is_alive and target and target.is_alive:
		var direction = (target.global_position - global_position).normalized()
		move_entity(direction)
		attack(target)
	else:
		move_entity(Vector2.ZERO)

func _on_detection_area_body_entered(body):
	if body is Player:
		target = body

func _on_detection_area_body_exited(body):
	if body is Player:
		target = null
