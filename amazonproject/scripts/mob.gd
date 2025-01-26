extends CharacterBody2D

var speed = 50
var player_chase = false
var target: Player

func _physics_process(delta):
	if !player_chase and target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func _on_detection_area_body_entered(body):
	if body is Player:
		target = body


func _on_detection_area_body_exited(body):
	if body is Player and body == target:
		player_chase = false
		target = null
