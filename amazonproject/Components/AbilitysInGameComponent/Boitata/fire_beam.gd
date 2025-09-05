extends Area2D

@export var damage: int = 50
@export var duration: float = 0.3

func _ready():
	await get_tree().create_timer(duration).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
		
