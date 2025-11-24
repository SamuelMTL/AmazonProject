extends AudioStreamPlayer2D

# Script para música começar e terminar em instantes específicos e em LOOP
# Música: [assets/sound/music/main_menu.mp3]

var loop_start_time: float = 10.0 # Instante inicial do loop (segundos)
var loop_end_time: float = 100.0 # Instante final do loop (segundos)
var loop_enabled: bool = false

# Fade-in
var target_volume: float = 5.0 # Volume normal
var silent_volume: float = -80.0 # Volume silenciado
var current_tween: Tween # Objeto que fará fade-in da música

func _ready() -> void:
	play_loop_with_fade_in(2.0, loop_start_time)

func _process(delta: float) -> void:
	if loop_enabled and is_playing():
		if get_playback_position() >= loop_end_time:
			play_loop_with_fade_in(2.0, loop_start_time)

func play_loop_with_fade_in(duration: float, from_pos: float):
	if current_tween:
		current_tween.kill() # Cancelar Tween ativo, se estiver (segurança)
	
	loop_enabled = true	
	volume_db = silent_volume
	play(from_pos) # Tocar música, a partir da posição desejada
	
	# Criar Tween e animar propriedade "volume_db" (fade in) até o volume desejado
	current_tween = create_tween()
	current_tween.tween_property(self, "volume_db", target_volume, duration)
