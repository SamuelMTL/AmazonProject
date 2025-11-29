extends Button

@export var label_text: String
@export var next_scene: String
@onready var click_sound = $"Click Sound"
@onready var hover_sound = $"Hover Sound"

# Avisar que "click" terminou! (útil para Menu de Pause)
signal click_finished

func _ready() -> void:
	text = label_text
	grab_focus()
	click_sound.volume_db = -5
	hover_sound.volume_db = -15

func _on_pressed() -> void:	
	click_sound.play()
	await get_tree().create_timer(0.5).timeout
	
	# "Click" terminou!
	click_finished.emit()

	if label_text == "Sair":
		get_tree().quit()
	# Trocar de cena APENAS se ela estiver definida (ou seja, APENAS no Menu Principal)
	elif next_scene != "":
		get_tree().change_scene_to_file(next_scene)

# Som ao passar o mouse por cima
func _on_mouse_entered() -> void:
	hover_sound.play()
