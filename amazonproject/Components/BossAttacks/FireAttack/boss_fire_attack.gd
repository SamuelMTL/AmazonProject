extends Node2D

@export var lifetime := 4.0  # segundos até desaparecer

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()
