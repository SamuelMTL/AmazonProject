extends Camera2D

var shake_strength: float = 0.0
var shake_time: float = 0.0

func shake(strength: float, duration: float) -> void:
	shake_strength = strength
	shake_time = duration

func _process(delta: float) -> void:
	if shake_time > 0:
		shake_time -= delta
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		offset = Vector2.ZERO
