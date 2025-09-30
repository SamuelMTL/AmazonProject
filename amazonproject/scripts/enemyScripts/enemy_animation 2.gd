extends Node


@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D
@onready var enemy : Enemy = get_owner()


func _physics_process(delta: float) -> void:
	if !enemy.alive:
		return
	
	if enemy.stunned:
		animation_player.play("stunned")
		return
	
	if !enemy.velocity:
		animation_player.play("idle")
		return
	
	sprite.flip_h = enemy.velocity.x < 0
	
	var animation_name = "walk"
	
	if enemy.velocity.length() > 50:
		animation_name = "run"
	
	
	if sprite.flip_h:
		animation_name += "_left"
	else:
		animation_name += "_right"
	
	animation_player.play(animation_name)
