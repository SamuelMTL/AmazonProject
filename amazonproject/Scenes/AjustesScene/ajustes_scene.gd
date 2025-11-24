extends Control

# Botões
@onready var music_btn = $VBoxContainer/Music
@onready var sfx_btn = $VBoxContainer/SFX
# Index dos canais de áudio (música e efeitos sonoros)
@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var sfx_bus_index = AudioServer.get_bus_index("SFX")

func _ready() -> void:
	# Se áudio estiver mudo, botão fica desmarcardo
	if AudioServer.is_bus_mute(music_bus_index):
		music_btn.button_pressed = 0
	if AudioServer.is_bus_mute(sfx_bus_index):
		sfx_btn.button_pressed = 0
	
func _process(delta: float) -> void:
	pass

# Mutar áudio, se for seletor estive desativado (e vice-versa)
func _on_music_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_mute(music_bus_index, false)
	else:
		AudioServer.set_bus_mute(music_bus_index, true)

func _on_sfx_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_mute(sfx_bus_index, false)
	else:
		AudioServer.set_bus_mute(sfx_bus_index, true)
