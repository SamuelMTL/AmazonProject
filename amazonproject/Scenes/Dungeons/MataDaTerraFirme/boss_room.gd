extends Node2D

@onready var camera = $Camera2D
@onready var player = $Jogador

var room_size = Vector2(640, 360)

var room_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/dungeon_room_MTF.tscn")

func _ready() -> void:
	build_room()
	
func _process(delta: float) -> void:
	update_position(camera)
	
func build_room():
	var room = room_scene.instantiate()
	add_child(room)
	
	room.get_node("Top/CollisionShape2D").disabled = false
	room.get_node("Left/CollisionShape2D").disabled = false
	room.get_node("Right/CollisionShape2D").disabled = false

func update_position(entidade):
	# Calcula a sala baseada na posição do jogador
	var current_room_x = int(player.position.x / room_size.x)
	var current_room_y = int(player.position.y / room_size.y)
	
	# Define o centro da sala como destino da câmera
	var target_position = Vector2((current_room_x + 0.5) * room_size.x,(current_room_y + 0.5) * room_size.y)
	
	# Move a câmera suavemente para a nova posição da sala
	entidade.position = target_position
