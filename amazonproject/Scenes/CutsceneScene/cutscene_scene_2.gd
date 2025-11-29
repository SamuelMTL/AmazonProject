extends Control

@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	anim_player.play("cutscene2")
	anim_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/aldeia.tscn")
