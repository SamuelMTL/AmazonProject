extends Node2D

@onready var camera = $Camera2D
@onready var player = $Player

var room_size = Vector2(640, 360)  # Ajuste para o tamanho real da sala

func _process(delta):
	update_camera_position()

func update_camera_position():
	# Calcula a sala baseada na posição do jogador
	var current_room_x = int(player.position.x / room_size.x)
	var current_room_y = int(player.position.y / room_size.y)
	
	# Define o centro da sala como destino da câmera
	var target_position = Vector2((current_room_x + 0.5) * room_size.x,(current_room_y + 0.5) * room_size.y)
	
	# Move a câmera suavemente para a nova posição da sala
	camera.position = target_position
