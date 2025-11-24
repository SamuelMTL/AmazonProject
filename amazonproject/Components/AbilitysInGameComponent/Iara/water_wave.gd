extends Area2D

@export var speed: float = 300
@export var push_force: float = 500
@export var duration: float = 1.5

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	await get_tree().create_timer(duration).timeout
	queue_free()
	
func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("apply_knockback"):
			body.apply_knockback(direction, push_force)
