class_name Player 
extends CombatEntity

@onready var animations = $AnimatedSprite2D

var enemy_in_range: bool = false
var target: CombatEntity = null

func _physics_process(delta):
	handle_input()
	update_animation()
	move_and_slide()
	
func handle_input():
	var move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	move_entity(move_direction)

	if Input.is_action_just_pressed("attack") and is_alive:
		if enemy_in_range and is_instance_valid(target):
			attack(target)

	
func update_animation():
	if velocity == Vector2.ZERO:
		animations.stop()
	else:
		if velocity.x > 0:
			animations.play("RightView")
		elif velocity.x < 0:
			animations.play("LeftView")
		elif velocity.y > 0:
			animations.play("DownView")
		else:
			animations.play("UpView")


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
