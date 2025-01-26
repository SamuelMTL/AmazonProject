extends CharacterBody2D

@onready var animations = $AnimatedSprite2D

const SPEED = 200

func _physics_process(delta):
	handle_input()
	update_animation()
	move_and_slide()
	
func handle_input():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * SPEED
	
func update_animation():
	var direction 
	
	if velocity.x < 0: 
		direction = "Left"
	elif velocity.x > 0:
		direction = "Right"
	elif velocity.y < 0:
		direction = "Up"
	else: 
		direction = "Down"
		
	animations.play(direction + "View")
