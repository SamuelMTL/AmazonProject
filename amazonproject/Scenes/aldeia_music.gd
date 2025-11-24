extends AudioStreamPlayer2D

func _ready() -> void:
	play()

func _process(delta: float) -> void:
	pass

func _on_finished() -> void:
	play()
