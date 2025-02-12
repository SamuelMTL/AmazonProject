extends Node2D

var dungeon_size = Vector2(3, 3)
var dungeon_layout = []
var max_rooms = 5
var start_pos = Vector2(1, 2)


#salas de 4 portas
var room1_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/4portas/dungeon_room_1.4.1.tscn")
var room2_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/4portas/dungeon_room_1.4.2.tscn")
var room3_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/4portas/dungeon_room_1.4.3.tscn")
#salas de 3 portas
var room4_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/3portas/dungeon_room_1.3.1.tscn") #top bottom right
var room5_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/3portas/dungeon_room_1.3.2.tscn") # top bottom left
var room6_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/3portas/dungeon_room_1.3.3.tscn") #top left right
var room7_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/3portas/dungeon_room_1.3.4.tscn") #bottom left right
#salas de 2 portas
var room8_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/2portas/dungeon_room_1.2.1.tscn") #right and left
var room9_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/2portas/dungeon_room_1.2.2.tscn") #top and bot
var room10_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/2portas/dungeon_room_1.2.3.tscn") #top and right
var room11_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/2portas/dungeon_room_1.2.4.tscn") #top and left
var room12_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/2portas/dungeon_room_1.2.5.tscn") #right and bottom
var room13_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/2portas/dungeon_room_1.2.6.tscn") #left and bottom
#salas de 1 porta
var room14_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/1porta/dungeon_room_1.1.1.tscn") #bottom
var room15_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/1porta/dungeon_room_1.1.2.tscn") #top
var room16_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/1porta/dungeon_room_1.1.3.tscn") #left
var room17_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/1porta/dungeon_room_1.1.4.tscn") #right

#primeira sala
var first_room_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/dungeon_room_1.0.tscn")

func _ready():
	generate_dungeon()
	build_dungeon()
	
func generate_dungeon():
	var size = 3
	dungeon_layout = []  # Reinicializa a matriz
	
	for i in range(size):
		dungeon_layout.append([])
		for j in range(size):
			dungeon_layout[i].append(0)
		
	var directions = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]
	var visited = []
	
	# Define o ponto inicial fixo (1, 2)
	var start_x = 2
	var start_y = 1
	dungeon_layout[start_x][start_y] = 2
	visited.append(Vector2(start_x, start_y))
	
	while len(visited) <= max_rooms:
		var current_pos = visited[randi() % len(visited)]
		directions.shuffle()  # Embaralha direções para caminhos variados
		
		for dir in directions:
			var new_x = current_pos.x + dir.x
			var new_y = current_pos.y + dir.y
			
			if new_x >= 0 and new_x < size and new_y >= 0 and new_y < size and dungeon_layout[new_x][new_y] == 0:
				dungeon_layout[new_x][new_y] = 1
				visited.append(Vector2(new_x, new_y))
				break  # Garante que estamos expandindo um caminho válido
				
	for row in dungeon_layout:
		print(row)
				
func build_dungeon():
	for row in range(dungeon_size.y):
		for col in range(dungeon_size.x):
			if dungeon_layout[row][col] > 0:
				var is_first_room = dungeon_layout[row][col] == 2
				build_room(col, row, is_first_room)
				
func build_room(x, y, is_first_room=false):
	var has_top = y > 0 and dungeon_layout[y - 1][x] > 0
	var has_bottom = y < dungeon_size.y - 1 and dungeon_layout[y + 1][x] > 0
	var has_left = x > 0 and dungeon_layout[y][x - 1] > 0
	var has_right = x < dungeon_size.x - 1 and dungeon_layout[y][x + 1] > 0
	
	var num_connections = int(has_top) + int(has_bottom) + int(has_left) + int(has_right)
	var room_scene = first_room_scene if is_first_room else get_room_by_connections(num_connections, has_top, has_bottom, has_left, has_right)
	
	var room = room_scene.instantiate()
	add_child(room)
	room.position = Vector2(x * 640, y * 360)
	
	
	room.get_node("FireWallTop/StaticBody2D/WallTopCollision").disabled = has_top
	room.get_node("FireWallTop/StaticBody2D/DoorTopCollision").disabled = not has_top
	room.get_node("FireWallTop/StaticBody2D/DoorTopCollision2").disabled = not has_top
	
	room.get_node("FireWallLeft/StaticBody2D/WallLeftCollision").disabled = has_left
	room.get_node("FireWallLeft/StaticBody2D/DoorLeftCollision").disabled = not has_left
	room.get_node("FireWallLeft/StaticBody2D/DoorLeftCollision2").disabled = not has_left
	
	room.get_node("FireWallRight/StaticBody2D/WallRightCollision").disabled = has_right
	room.get_node("FireWallRight/StaticBody2D/DoorRightCollision").disabled = not has_right
	room.get_node("FireWallRight/StaticBody2D/DoorRightCollision2").disabled = not has_right
	
	
	room.get_node("FireWallCorners").play("fire_corners")
	
	if is_first_room:
		#a colisao na primeira sala é diferente, nunca vai ter uma sala no bottom 
		#mas ela precisa ter a porta aberta
		room.get_node("FireWallBottom/StaticBody2D/WallBottomCollision").disabled = true
		room.get_node("FireWallBottom/StaticBody2D/DoorBottomCollision").disabled = false
		room.get_node("FireWallBottom/StaticBody2D/DoorBottomCollision2").disabled = false
		# Configuração específica para a primeira sala
		room.get_node("FireWallBottom").play("bottomWall_open")
	else:
		room.get_node("FireWallBottom/StaticBody2D/WallBottomCollision").disabled = has_bottom
		room.get_node("FireWallBottom/StaticBody2D/DoorBottomCollision").disabled = not has_bottom
		room.get_node("FireWallBottom/StaticBody2D/DoorBottomCollision2").disabled = not has_bottom
		# Configura portas normais
		room.get_node("FireWallBottom").play("bottomWall_open" if has_bottom else "bottomWall_closed")
		
	room.get_node("FireWallTop").play("topWall_open" if has_top else "topWall_closed")
	room.get_node("FireWallLeft").play("leftWall_open" if has_left else "leftWall_closed")
	room.get_node("FireWallRight").play("rightWall_open" if has_right else "rightWall_closed")

func get_room_by_connections(num_connections, has_top, has_bottom, has_left, has_right):
	var connection_pattern = ""
	
	connection_pattern += "T" if has_top else "F"
	connection_pattern += "B" if has_bottom else "F"
	connection_pattern += "L" if has_left else "F"
	connection_pattern += "R" if has_right else "F"
	
	match connection_pattern:
		"TFFF": return room15_scene # 1 porta top
		"FBFF": return room14_scene # 1 porta bottom
		"FFLF": return room16_scene # 1 porta left
		"FFFR": return room17_scene # 1 porta right
		"FFLR": return room8_scene # 2 portas left right
		"TBFF": return room9_scene #2 portas top bot
		"TFFR": return room10_scene #2 portas top right
		"TFLF": return room11_scene #2 portas top left
		"FBFR": return room12_scene #2 portas bot right
		"FBLF": return room13_scene #2 portas bot left
		"TBFR": return room4_scene #3 portas top bot right
		"TBLF": return room5_scene #3portas top bot left
		"TFLR": return room6_scene #3portas top left right
		"FBLR": return room7_scene #3 portas bot left right
		_:
			return [room1_scene, room2_scene, room3_scene][randi() % 3]
		
		
