extends AudioStreamPlayer

@onready var audio_stream_duration = stream.get_length()

@onready var loop_enabled: bool = false
@onready var loop_start_time: float = 0.5
@onready var loop_end_time: float = 1.0
@onready var loop_elapsed_time: float = 0.0
@onready var fire_attack = $".." # Usar a variável "lifetime"

func _process(delta: float) -> void:
	if loop_enabled:
		if is_playing() and get_playback_position() >= loop_end_time:
			play_loop(loop_start_time)

func play_loop(from_pos: float):
	if loop_enabled:
		play(from_pos)
		loop_elapsed_time += (loop_end_time - loop_start_time)
	else:
		play()
		loop_elapsed_time += audio_stream_duration
		loop_enabled = true
	
	print("loop_elapsed_time = ", loop_elapsed_time)
	
	# Parar o loop!	
	if loop_elapsed_time >= fire_attack.lifetime + 1:
		loop_enabled = false
		loop_elapsed_time = 0.0
		print("Parando o loop...")
