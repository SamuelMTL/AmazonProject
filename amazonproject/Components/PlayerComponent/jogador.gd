class_name Player
extends CharacterBody2D

@onready var animations = $AnimatedSprite2D
@onready var attack_timer : Timer = $AttackCooldownTimer

@export var speed: float = 150
@export var attack_damage: int = 20
@export var attack_cooldown_time: float = 1.0

const DASH_SPEED = 900
var dashing = false
var can_dash = true

var is_attacking = false
var is_alive = true
var enemy_in_range: bool = false
var attack_cooldown = false

var weapon_equiped: String

var last_direction = "down"


func _physics_process(delta):
	handle_input()
	update_animation()
	move_and_slide()
	
func move_entity(direction: Vector2):
	velocity = direction.normalized() * speed
	move_and_slide()

func handle_input():
	var move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$DashTimer.start()
		$DashCooldown.start() 
		
	if dashing:
		player_dash(move_direction)
	else:
		move_entity(move_direction)
		
			
func player_dash(direction: Vector2):
	velocity = direction.normalized() * DASH_SPEED

func update_animation():
	if is_attacking:
		match last_direction:
			"right":
				animations.play("RightAttacking")
			"left":
				animations.play("LeftAttacking")
			"down":
				animations.play("DownAttacking")
			"up":
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
	
func attack():
	pass
			
func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_cooldown_timeout() -> void:
	can_dash = true


func _on_attack_cooldown_timeout() -> void:
	attack_cooldown = false
	is_attacking = false 
