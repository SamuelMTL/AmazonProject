extends Button

@export var label_text: String
@onready var click_sound = $"../../../Click Sound"
@onready var hover_sound = $"../../../Hover Sound"

func _ready() -> void:
	text = label_text
	click_sound.volume_db = -5
	hover_sound.volume_db = -15
	grab_focus()

func _on_pressed() -> void:
	click_sound.play()

func _on_mouse_entered() -> void:
	hover_sound.play()
