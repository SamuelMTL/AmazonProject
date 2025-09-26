class_name Enemy
extends CharacterBody2D


signal damaged(attack: Attack)

@export_group("Vision Ranges")
@export var detection_radius: float = 100.0
@export var chase_radius: float = 200.0
# This guy doesn't actually attack, he just tries to get close to the player
@export var follow_radius: float = 25.0

var isAlive: bool = true
var isStunned: bool = false

func _ready():
	move_and_slide()
	#sprite.texture = textures.pick_random()


func on_damaged(attack: Attack) -> void:
	damaged.emit(attack)
