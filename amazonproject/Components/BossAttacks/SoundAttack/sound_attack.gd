extends Node2D

@export var speed: float = 250.0
@export var direction: Vector2 = Vector2.DOWN
@export var lifetime: float = 4.0

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
