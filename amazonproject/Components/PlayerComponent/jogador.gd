class_name Player
extends CharacterBody2D

@onready var animations = $AnimatedSprite2D
@onready var attack_timer : Timer = $AttackCooldown
@onready var walking_sound = $WalkingSound # Som dos passos
@onready var attack_sound = $AttackSound # Som de ataque (como só tem o "tacape", por enquanto, então não especifiquei "de qual arma")

@export var speed: float = 150
@export var attack_cooldown_time: float = 1.0

@export var attack_damage: float = 5.0

const DASH_SPEED = 900
var dashing = false
var can_dash = true

var is_attacking = false
var is_alive = true
var enemy_in_range: bool = false
var attack_cooldown = false

var enemies_in_melee_range = []
var enemies_in_lanca_range = []
var weapon_equiped = "tacape"

var last_direction = "down"
	
var fire_trail_active = false
@export var fire_trail_duration: float = 5.0
@export var fire_trail_cooldown: float = 10.0
var can_use_fire_trail = true
var last_trail_time = 0.0
@export var trail_spawn_interval: float = 0.2

var can_use_water_wave = true
@export var water_wave_cooldown = 6.0

var can_use_fire_beam = true
@export var fire_beam_cooldown = 8.0

@onready var fire_beam_scene = preload("res://Components/AbilitysInGameComponent/Boitata/FireBeam.tscn")
@onready var water_wave_scene = preload("res://Components/AbilitysInGameComponent/Iara/WaterWave.tscn")
@onready var fire_trail_scene = preload("res://Components/AbilitysInGameComponent/Curupira/FireTrail.tscn")

func _physics_process(delta):
	handle_input()
	update_animation()
	move_and_slide()
	
	if fire_trail_active and velocity != Vector2.ZERO:
		spawn_fire_trail()
		
	
func move_entity(direction: Vector2):
	velocity = direction.normalized() * speed
	move_and_slide()
	# Som dos passos se estiver andando (velocity):
	if velocity:
		walking_sound.is_walking = true
	else:
		walking_sound.is_walking = false

func handle_input():
	var move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_action_just_pressed("dash") and can_dash:
		player_dash(move_direction)
		can_dash = false
		$DashTimer.start()
		$DashCooldown.start() 
		
	if dashing:
		player_dash(move_direction)
	else:
		move_entity(move_direction)
		
	if Input.is_action_just_pressed("attack"):
		attack()
			
	if Input.is_action_just_pressed("equip_tacape"):
		weapon_equiped = "tacape"
		print("tacape equipado")
	elif Input.is_action_just_pressed("equip_lanca"):
		weapon_equiped = "lanca"
		print("lanca_equipada")
	elif Input.is_action_just_pressed("equip_boleadeira"):
		weapon_equiped = "boleadeira"
		print("boleadeira equipada")
	elif Input.is_action_just_pressed("equip_zarabatana"):
		weapon_equiped = "zarabatana"
		print("zarabatana equipada")
		
	if Input.is_action_just_pressed("CurupiraPower"):
		activate_curupira_power()
	elif Input.is_action_just_pressed("IaraPower"):
		activate_iara_power()
	elif Input.is_action_just_pressed("BoitataPower"):
		activate_boitata_power()
			
func player_dash(direction: Vector2):
	dashing = true
	can_dash = false
	velocity = direction.normalized() * DASH_SPEED

func update_animation():
	if is_attacking:
		match last_direction:
			"right":
				if animations.animation != "RightAttacking":
					animations.play("RightAttacking")
			"left":
				if animations.animation != "LeftAttacking":
					animations.play("LeftAttacking")
			"down":
				if animations.animation != "DownAttacking":
					animations.play("DownAttacking")
			"up":
				if animations.animation != "UpAttacking":
					animations.play("UpAttacking")
				
	elif velocity == Vector2.ZERO:
		
		match last_direction:
			"right":
				animations.play("RightIdle")
			"left":
				animations.play("LeftIdle")
			"down":
				animations.play("DownIdle")
			"up":
				animations.play("UpIdle")
			
	else:
		if velocity.x > 0:
			animations.play("LeftWalking")
			last_direction = "right"
		elif velocity.x < 0:
			animations.play("RightWalking")
			last_direction = "left"
		elif velocity.y > 0:
			animations.play("DownWalking")
			last_direction = "down"
		else:
			animations.play("UpWalking")
			last_direction = "up"

func activate_curupira_power():
	if not can_use_fire_trail:
		return
		
	fire_trail_active = true
	can_use_fire_trail = false
	
	await get_tree().create_timer(fire_trail_duration).timeout
	fire_trail_active = false
	
	await get_tree().create_timer(fire_trail_cooldown).timeout
	can_use_fire_trail = true
	
func spawn_fire_trail():
	if Time.get_ticks_msec() / 1000.0 - last_trail_time >= trail_spawn_interval:
		var fire = fire_trail_scene.instantiate()
		fire.position = global_position
		get_parent().add_child(fire)
		last_trail_time = Time.get_ticks_msec() / 1000.0
	
func activate_iara_power():
	if not can_use_water_wave:
		return
	
	can_use_water_wave = false
	
	var wave = water_wave_scene.instantiate()
	wave.position = global_position
	wave.direction = get_facing_direction()
	wave.rotation = get_facing_angle()
	get_parent().add_child(wave)
	
	await get_tree().create_timer(water_wave_cooldown).timeout
	can_use_water_wave = true
	
func activate_boitata_power():
	if not can_use_fire_beam:
		return
	
	can_use_fire_beam = false
	
	var beam = fire_beam_scene.instantiate()
	beam.position = global_position
	beam.rotation = get_facing_angle()
	get_parent().add_child(beam)	
	
	await get_tree().create_timer(fire_beam_cooldown).timeout
	can_use_fire_beam = true
	

func attack():
	if attack_cooldown or not is_alive:
		return
		
	is_attacking = true
	attack_cooldown = true
	attack_timer.start(attack_cooldown_time)
	
	match weapon_equiped:
		"tacape":
			tacape_attack()
		"lanca":
			lanca_attack()
		"boleadeira":
			boleadeira_attack()
		"zarabatana":
			zarabatana_attack()
		_:
			print("No weapon equipped")
			
func tacape_attack():
	attack_sound.play(0.1) # Tocar som de ATAQUE
	for enemy in get_overlapping_bodies():
		if enemy.is_in_group("enemies"):
			enemy.take_damage(10)
			var direction = enemy.global_position - global_position
			var force = 200.0 # ajuste conforme necessário
			enemy.apply_knockback(direction, force)
		elif enemy.is_in_group("Boss"):
			enemy.take_damage(10)

func lanca_attack():
	for enemy in get_overlapping_bodies():
		if enemy.is_in_group("enemies"):
			enemy.take_damage(20)
			enemy.apply_knockback()

func boleadeira_attack():
	pass

func zarabatana_attack():
	var projectile_scene = preload("res://Components/WeaponsComponent/ProjectileComponent/Projectile.tscn")
	var projectile = projectile_scene.instantiate()
	projectile.position = global_position
	projectile.direction = get_facing_direction()
	get_parent().add_child(projectile)
			
func get_facing_direction() -> Vector2:
	match last_direction:
		"right":
			return Vector2(1, 0)
		"left":
			return Vector2(-1, 0)
		"down":
			return Vector2(0, 1)
		"up":
			return Vector2(0, -1)
	return Vector2(0, 0)
	
func get_facing_angle() -> float:
	match last_direction:
		"right": return 0
		"down": return PI / 2
		"left": return PI
		"up": return -PI/2
	return 0
	
func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

func _on_attack_cooldown_timeout() -> void:
	attack_cooldown = false
	is_attacking = false 

		
func get_overlapping_bodies():
	if weapon_equiped == "tacape":
		return enemies_in_melee_range
	elif weapon_equiped == "lanca":
		return enemies_in_lanca_range
	else:
		return


func _on_melee_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_melee_range.erase(body)


func _on_lanca_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_lanca_range.append(body)


func _on_lanca_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_lanca_range.erase(body)


func _on_melee_attack_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_melee_range.append(body)
		print(enemies_in_melee_range)

func take_damage(amount: int):
	if not dashing:
		Global.player_health -= amount
		print(Global.player_health)
		if Global.player_health <= 0:
			die()
		
func die():
	get_tree().change_scene_to_file("res://Scenes/GameOver/GameOverScene.tscn")
