extends AudioStreamPlayer2D

# Script para música de pause, em LOOP
# Música: [assets/sound/music/pause.mp3]

var loop_start_time: float = 0.0
var loop_end_time: float = 27.25
var loop_enabled: bool = false

var pause_volume: float = -5.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# Tocar músicas apenas se "PauseComponent" estiver visível:
	if get_node("..").visible:
		if not loop_enabled:
			play_loop()
		elif loop_enabled and is_playing():
			if get_playback_position() >= loop_end_time:
				play_loop()
	else:
		stop_loop()

func play_loop():
	loop_enabled = true
	volume_db = pause_volume
	play()
	
func stop_loop():
	loop_enabled = false
	stop()
