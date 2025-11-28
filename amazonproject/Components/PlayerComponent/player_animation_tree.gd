extends Node2D

@export var animation_tree: AnimationTree
@onready var player: Player = get_owner()

var last_facing_direction:= Vector2(0, -1)

func _physics_process(delta: float) -> void:
	
	var idle = !player.velocity 
	
	if !idle:
		last_facing_direction = player.velocity.normalized()

	animation_tree.set("parameters/PlayerStates/Walking/blend_position", last_facing_direction)
	animation_tree.set("parameters/PlayerStates/Idle/blend_position", last_facing_direction)
	animation_tree.set("parameters/PlayerStates/Attack/blend_position", last_facing_direction)
	pass
