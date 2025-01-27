class_name CombatEntity
extends CharacterBody2D

@export var health: int = 100
@export var attack_damage: int = 20
@export var attack_cooldown_time: float = 1.0
@export var speed: float = 200

@onready var attack_timer : Timer = $AttackCooldownTimer

var is_attacking = false
var attack_cooldown = false
var is_alive = true

func _ready():
	attack_timer.connect("timeout", Callable(self, "_on_attack_cooldown_timer_timeout"))
	
func move_entity(direction: Vector2):
	velocity = direction.normalized() * speed
	move_and_slide()
	
func take_damage(amount: int):
	if not is_alive:
		return
	health -= amount
	print(health)
	if health <= 0:
		health = 0
		is_alive = false
		on_death()
		
func on_death():
	queue_free()
	
func attack(target: CombatEntity):
	if is_attacking or attack_cooldown or not is_alive:
		return
	is_attacking = true
	attack_cooldown = true
	target.take_damage(attack_damage)
	print("Attacked target: " + str(target))
	
	# Inicia o cooldown do ataque
	attack_timer.start(attack_cooldown_time)

func _on_attack_cooldown_timer_timeout():
	attack_cooldown = false
	is_attacking = false 
