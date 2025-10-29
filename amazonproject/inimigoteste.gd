class_name Enemy2
extends CharacterBody2D

@export var max_health: int = 100
var current_health: int = max_health

@export var move_speed: float = 50.0
@export var detection_radius: float = 200.0

@export var stop_distance: float = 20.0

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_time: float = 0.0

@onready var sprites = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("Player")

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
						}
						
					}
				}
			}

func _ready() -> void:
	choose_sprite("espantalho")

func _physics_process(delta: float) -> void:
	if knockback_time > 0:
		position += knockback_velocity * delta
		knockback_time -= delta
		return
		
	if player and is_instance_valid(player):
		var distance = position.distance_to(player.position)
		
		if distance <= detection_radius and distance > stop_distance:
			var direction = (player.position - position).normalized()
			velocity = direction * move_speed
		else:
			velocity = Vector2.ZERO
			
		move_and_slide()

func apply_knockback(direction: Vector2, force: float):
	knockback_velocity = direction.normalized() * force
	knockback_time = 0.05
	
func take_damage(amount: int):
	current_health -= amount
	print("enemy hit")
	if current_health <= 0:
		die()
		
func die():
	queue_free()
	Global.enemy_counter -= 1
	
func choose_sprite(enemy: String):
	sprites.play(inimigos[enemy]["animacoes"]["walk"]["right"])
	
		
	
