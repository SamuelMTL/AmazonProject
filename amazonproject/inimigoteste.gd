class_name Enemy2
extends CharacterBody2D

@export var max_health: int = 20
var current_health: int = max_health

@export var move_speed: float = 50.0
@export var detection_radius: float = 200.0

@export var stop_distance: float = 20.0

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_time: float = 0.0
var room_id = 0

var can_attack = true

var player_in_range: Node2D = null
var attack_delay := 0.2

var is_taking_damage: bool = false
var last_direction := "right"  # usado para idle e damage

var is_dying: bool = false
var is_attacking := false

signal died(room_id)

@onready var attack_timer = $Timer
@onready var sprites = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("Player")

@export var chase_radius: float = 250.0
@export var follow_radius: float = 25.0 

@onready var die_sound = $"DieSound"

var inimigos = { 
		"espantalho": {
			"dano": 10, 
			"animacoes": { 
						"idle": 
							{ 
							"down": "EspantalhoIdleDown",
							"up": "EspantalhoIdleUp",
							"left": "EspantalhoIdleEsquerda",
							"right": "EspantalhoIdleDireita"
							},
						"walk": {
							"down": "EspantalhoAndandoDown",
							"up": "EspantalhoAndandoUp",
							"left": "EspantalhoAndandoEsquerda",
							"right": "EspantalhoAndandoDireita"
						},
						"morrendo": {
							"right": "EspantalhoMorrendoDireita",
							"left": "EspantalhoMorrendoEsquerda"
						},
						"damage": {
							"down": "EspantalhoSofrendoDireita",
							"up": "EspantalhoSofrendoDireita",
							"left": "EspantalhoSofrendoEsquerda",
							"right": "EspantalhoSofrendoDireita"
						},
						"atacando1": {
							"right": "EspantalhoAtacando1Direita",
							"left": "EspantalhoAtacando1Esquerda",
							"up": "EspantalhoAtacando1Esquerda",
							"down": "EspantalhoAtacando1Direita"
						},
						"atacando2": {
							"right": "EspantalhoAtacando2Direita",
							"left": "EspantalhoAtacando2Esquerda",
							"up": "EspantalhoAtacando2Esquerda",
							"down": "EspantalhoAtacando2Direita"
							
						},
						
						
					},
				"drop": ""
				}
			}

func _ready() -> void:
	z_index = 10
	print("Enemy ready: ", self)

func _physics_process(delta: float) -> void:
	if is_dying:
		return
		
	if knockback_time > 0:
		position += knockback_velocity * delta
		knockback_time -= delta
		return
		
	var direction: Vector2 = player.global_position - global_position
	
	var distance = direction.length()
	if distance > chase_radius:
		velocity = Vector2.ZERO
		return
	velocity = direction.normalized()* move_speed
	
	if distance <= follow_radius:
		velocity = Vector2.ZERO
	
	choose_sprite("espantalho", velocity)
	move_and_slide()

func apply_knockback(direction: Vector2, force: float):
	knockback_velocity = direction.normalized() * force
	knockback_time = 0.05
	
func take_damage(amount: int):
	if is_dying:
		return
	if is_taking_damage:
		return  # evita tocar dano duas vezes ao mesmo tempo
	
	is_taking_damage = true
	current_health -= amount
	
	# Determina direção atual para tocar a animação de dano
	var anim = inimigos["espantalho"]["animacoes"]["damage"][last_direction]
	sprites.play(anim)

	print("enemy hit")

	# Aguarda fim da animação de dano
	await sprites.animation_finished

	is_taking_damage = false

	# Se morreu durante o hit, não volta pra idle
	if current_health <= 0:
		die()
		return

	# Volta ao idle da ultima direção
	var idle_anim = inimigos["espantalho"]["animacoes"]["idle"][last_direction]
	sprites.play(idle_anim)
	
func attack(body: Node2D): 
	if body.is_in_group("Player") and can_attack == true and not is_taking_damage :
		is_attacking = true
		can_attack = false
	
		var attack_anim = get_random_attack_anim("espantalho")
		print("ANIMAÇÃO SELECIONADA:", attack_anim)

		sprites.play(attack_anim)
		print("ANIMAÇÃO TOCANDO AGORA:", sprites.animation)

		await sprites.animation_finished
		if player_in_range == body:
			print("chegou — PLAYER AINDA NO RANGE")
			body.take_damage(10)
		else:
			print("chegou — MAS PLAYER SAIU DO RANGE, ATAQUE CANCELADO")
		is_attacking = false
		attack_timer.start()
			
func drop_item(enemy: String):
	var item = preload("res://Components/InventarioComponent/item.tscn")
	var item_instance = item.instantiate()
	item_instance.position = global_position
	get_parent().add_child(item_instance)
	
func die():

	if is_dying:
		return

	is_dying = true
	is_taking_damage = false  # cancela dano se estiver acontecendo

	# Escolhe animação de morte com base na última direção
	var death_anim = inimigos["espantalho"]["animacoes"]["morrendo"][last_direction]
	sprites.play(death_anim)

	# Espera a animação terminar antes de liberar
	await sprites.animation_finished

	# Drop antes de sumir
	drop_item("espantalho")

	emit_signal("died", room_id)


	die_sound.play()


	Global.enemy_counter -= 1

	queue_free()
	
func choose_sprite(enemy: String, velocity: Vector2):
	if is_taking_damage or is_attacking or is_dying:
		return  # não troca animação durante hit

	# movimento horizontal
	if velocity.x > 0:
		last_direction = "right"
		sprites.play(inimigos[enemy]["animacoes"]["walk"]["right"])

	elif velocity.x < 0:
		last_direction = "left"
		sprites.play(inimigos[enemy]["animacoes"]["walk"]["left"])

	# se não tem movimento horizontal → usar idle
	else:
		var idle_anim = inimigos[enemy]["animacoes"]["idle"][last_direction]
		sprites.play(idle_anim)
	
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = body
		start_attack_delay()

func _on_timer_timeout() -> void:
	can_attack = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = null
		
func start_attack_delay():
	await get_tree().create_timer(attack_delay).timeout

	if player_in_range and can_attack:
		attack(player_in_range)

func get_random_attack_anim(enemy: String) -> String:
	var attacks = ["atacando1", "atacando2"]
	var random_attack = attacks[randi() % attacks.size()]
	return inimigos[enemy]["animacoes"][random_attack][last_direction]
