extends Node2D

@export var lifetime := 4.0  # segundos até desaparecer
@onready var animation_player = $AnimationPlayer
@onready var fire_attack_sound = $"FireAttackSound"

func _ready():
	fire_attack_sound.play_loop(fire_attack_sound.loop_start_time)
	await get_tree().create_timer(lifetime).timeout
	animation_player.play("end_animation")
	await animation_player.animation_finished

	queue_free()

func _on_rigid_body_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(10)
