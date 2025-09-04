class_name Enemy
extends CharacterBody2D

@export var max_health: int = 10
var current_health: int = max_health

func take_damage(amount: int):
	current_health -= amount
	print("enemy hit")
	if current_health <= 0:
		die()
		
func die():
	queue_free()
