extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		visible = true

func _on_continuar_pressed() -> void:
	visible = false
	get_tree().paused = false

func _on_ajustes_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/AjustesScene/AjustesScene.tscn")
	get_tree().paused = false

func _on_sair_pressed() -> void:
	get_tree().quit()
