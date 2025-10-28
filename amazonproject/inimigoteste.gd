class_name Enemy2
extends CharacterBody2D

@export var max_health: int = 100
var current_health: int = max_health

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_time: float = 0.0

@onready var sprites = $Sprite2D

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
	sprites.play(inimigos["animacoes"]["walk"])
	
		
	
