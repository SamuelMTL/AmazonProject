extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Habilidades"):
		get_tree().paused = true
		visible = true


func _on_button_pressed() -> void:
	visible = false
	get_tree().paused = false
