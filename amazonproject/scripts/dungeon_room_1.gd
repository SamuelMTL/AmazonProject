extends Node2D

@onready var fire_barrier_animation = $FireWall

func _ready():
	fire_barrier_animation.play("fire_corners")
