extends AudioStreamPlayer2D

# Script para "encaixar" melhor a música à animação
# Uma das batidas está sincronizada com o abrir de olhos da Caipora :S
# Música: "Think About It" - Bryan Teoh [assets/sound/music/cutscene1.mp3]

var target_volume: float = 10.0
var silent_volume: float = -80.0
var current_tween: Tween # Objeto que fará fade-in e fade-out da música

func _ready() -> void:
	play_with_fade_in(2.0, 3.2)
	await get_tree().create_timer(17.0).timeout
	stop_with_fade_out(1.0)

func _process(delta: float) -> void:
	pass

func play_with_fade_in(duration: float, from_pos: float = 0.0):
	if current_tween:
		current_tween.kill()
		
	volume_db = silent_volume
	play(from_pos)
	
	current_tween = create_tween()
	current_tween.tween_property(self, "volume_db", target_volume, duration)

func stop_with_fade_out(duration: float):
	if current_tween:
		current_tween.kill()
	
	# Criar novo Tween e animar (fade out) propriedade "volume_db" até silenciar volume
	current_tween = create_tween()
	current_tween.tween_property(self, "volume_db", silent_volume, duration)
	
	# Parar música, apenas quando Tween também terminar (segurança)
	current_tween.tween_callback(stop)
