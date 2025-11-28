extends AudioStreamPlayer

@onready var is_walking: bool = false
@onready var prev_is_walking: bool = false

func _ready() -> void:
	volume_db = -12.0
	pitch_scale = 2.35

func _process(delta: float) -> void:
	if is_walking:
		if prev_is_walking:
			if get_playback_position() >= 0.8:
				play()
		else:
			play()
			prev_is_walking = is_walking
	else:
		prev_is_walking = false
