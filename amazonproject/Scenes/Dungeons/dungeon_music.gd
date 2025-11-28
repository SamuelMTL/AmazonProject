extends AudioStreamPlayer

var loop_start_time: float = 0.0
var loop_end_time: float = 81.85
var loop_enabled: bool = false

var duration: float = 0.4 # Duração do fade-in
var target_volume: float = 0.0
var silent_volume: float = -80.0
var current_tween: Tween

func _ready() -> void:
	play_loop_with_fade_in(duration, loop_start_time)
	loop_start_time = 0.05 # Correção do tempo inicial do loop para "suavizá-lo"

func _process(delta: float) -> void:
	if loop_enabled and is_playing():
		if get_playback_position() >= loop_end_time:
			play(loop_start_time)
	
func play_loop_with_fade_in(duration: float, from_pos: float) -> void:
	if current_tween:
		current_tween.kill

	loop_enabled = true
	volume_db = silent_volume
	play(from_pos)
	
	current_tween = create_tween()
	current_tween.tween_property(self, "volume_db", target_volume, duration)
