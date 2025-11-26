extends Node2D

@export var speed: float = 400
@export var damage: int = 50

var direction: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	position += direction * speed * delta
	rotation = direction.angle() + deg_to_rad(90)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(damage)
		queue_free()
