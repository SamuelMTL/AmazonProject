extends CharacterBody2D

var player: Node2D
var fire_attack_component = preload("res://Components/BossAttacks/FireAttack/BossFireAttack.tscn")
var sound_attack_component = preload("res://Components/BossAttacks/SoundAttack/SoundAttack.tscn")
var boss_body_lanca_attack = preload("res://Components/BossAttacks/LancaAttack/BossBodyLancaAttack.tscn")
var boss_lanca_component = preload("res://Components/BossAttacks/LancaAttack/BossLanca.tscn")

var attack_interval := 6.0  # tempo entre ataques
var attack_index := 0
var attacks = []  # lista de funções

var lanca_attack_timer := 2
var boss_body = boss_body_lanca_attack.instantiate()

var boss_health = 100

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
	attacks = [
		Callable(self, "use_fire_attack"),
		Callable(self, "use_sound_attack"),
		Callable(self, "use_lanca_attack"),
	]

	start_attack_cycle()
	
func _process(delta: float) -> void:
	if boss_body:
		boss_body.look_at(player.global_position)
	
func attack_cycle() -> void:
	while true:
		# pega o ataque atual
		var attack_func = attacks[attack_index]

		# executa
		attack_func.call()

		# avança para o próximo ataque
		attack_index = (attack_index + 1) % attacks.size()

		# espera antes do próximo
		await get_tree().create_timer(attack_interval).timeout
		
func start_attack_cycle() -> void:
	attack_cycle()
	
func take_damage(amount: int):
	boss_health -= amount
	print("boss hit")
	if boss_health <= 0:
		die()
		
func die():
	#colocar a animacao do boss morrendo
	PlayerInventory.powerups.append("Curupira")
	get_tree().change_scene_to_file("res://Scenes/CutsceneScene/CutsceneScene2.tscn")

func use_fire_attack():
	var amount = 5
	var radius = 120
	
	for i in amount: 
		var fire = fire_attack_component.instantiate()
		var offset = Vector2(
			randf_range(-radius, radius),
			randf_range(-radius, radius)
		)
		
		if offset.length() > radius:
			offset = offset.normalized() * radius
			
		fire.position = player.position + offset
		get_tree().current_scene.add_child(fire)
	
	
func use_sound_attack():
	var attack = sound_attack_component.instantiate()
	get_tree().current_scene.add_child(attack)
	attack.position = position
	
	# treme a câmera
	var camera = get_tree().get_first_node_in_group("Cameras") 
	if camera:
		camera.shake(8.0, 0.4) # força, duração
	
	
func use_lanca_attack():
	get_tree().current_scene.add_child(boss_body)
	boss_body.position = position
	
	await get_tree().create_timer(lanca_attack_timer).timeout
	shoot_lanca()
	
func shoot_lanca():
	var lanca = boss_lanca_component.instantiate()
	get_tree().current_scene.add_child(lanca)
	lanca.global_position = boss_body.global_position
	lanca.direction = (player.global_position - boss_body.global_position).normalized()
	
	
	
