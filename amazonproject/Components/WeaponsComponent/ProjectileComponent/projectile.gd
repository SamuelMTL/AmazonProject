extends Area2D

@export var speed: float = 400
@export var damage: int = 10

var direction: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position+= direction.normalized() * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		queue_free()
