extends Control

# Som de GAME OVER
@onready var game_over_sound = $"GameOverSound"

func _ready() -> void:
	game_over_sound.play()

func _process(delta: float) -> void:
	pass
