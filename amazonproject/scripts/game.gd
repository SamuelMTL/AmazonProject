extends Node2D

@onready var fire_barrier_animation = $AnimatedSprite2D

func _ready():
	fire_barrier_animation.play("fire_barrier")
