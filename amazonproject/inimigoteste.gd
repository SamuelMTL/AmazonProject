class_name Enemy2
extends CharacterBody2D

@export var max_health: int = 10
var current_health: int = max_health

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_time: float = 0.0

func _physics_process(delta: float) -> void:
	if knockback_time > 0:
		position += knockback_velocity * delta
		knockback_time -= delta

func apply_knockback(direction: Vector2, force: float):
	knockback_velocity = direction.normalized() * force
	knockback_time = 0.05
	
func take_damage(amount: int):
	current_health -= amount
	print("enemy hit")
	if current_health <= 0:
		die()
		
func die():
	queue_free()
