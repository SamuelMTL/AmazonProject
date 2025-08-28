extends Button

@export var label_text: String
@export var next_scene: String

func _ready() -> void:
	text = label_text

func _on_pressed() -> void:
	if label_text == "Sair":
		get_tree().quit()
	else:
		get_tree().change_scene_to_file(next_scene)
