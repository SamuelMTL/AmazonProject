class_name Player 
extends CombatEntity

@onready var animations = $AnimatedSprite2D

var enemy_in_range: bool = false
var target: CombatEntity = null

var last_direction = "down"

const DASH_SPEED = 900
var dashing = false
var can_dash = true

func _physics_process(delta):
	handle_input()
	update_animation()
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
		
	if Input.is_action_just_pressed("attack") and is_alive:
		if enemy_in_range and is_instance_valid(target):
			attack(target)

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


func _on_hit_box_body_entered(body):
	if body is CombatEntity and body != self:  
		enemy_in_range = true
		target = body


func _on_hit_box_body_exited(body):
	if body is CombatEntity and body == target:
		enemy_in_range = false
		target = null

func on_death():
	print("Player morreu!")
	get_tree().change_scene_to_file("res://scenes/aldeia.tscn")
	health = 100


func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
