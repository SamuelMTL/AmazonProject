extends Area2D

@export var damage: int = 5
@export var duration: float = 2.0
@export var damage_interval: float = 0.5

var enemies_in_fire = []

func _ready() -> void:
	await get_tree().create_timer(duration).timeout
	queue_free()
	
func _process(delta: float) -> void:
	for enemy in enemies_in_fire:
		if enemy and enemy.has_method("take_damage"):
			enemy.take_damage(damage * delta)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_fire.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body in enemies_in_fire:
		enemies_in_fire.erase(body)
		
