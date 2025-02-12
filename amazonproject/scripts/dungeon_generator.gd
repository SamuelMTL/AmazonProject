extends Node2D

var dungeon_size = Vector2(3, 3)
var dungeon_layout = [] #isso aqui vai armazenar o layout criado

#salas de 4 portas
var room1_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/4portas/dungeon_room_1.4.1.tscn")
var room2_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/4portas/dungeon_room_1.4.2.tscn")
var room3_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/4portas/dungeon_room_1.4.3.tscn")
#salas de 3 portas
var room4_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/3portas/dungeon_room_1.3.1.tscn")
var room5_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/3portas/dungeon_room_1.3.2.tscn")
var room6_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/3portas/dungeon_room_1.3.3.tscn")
var room7_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/3portas/dungeon_room_1.3.4.tscn")
#salas de 2 portas
var room8_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/2portas/dungeon_room_1.2.1.tscn")
var room9_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/2portas/dungeon_room_1.2.2.tscn")
var room10_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/2portas/dungeon_room_1.2.3.tscn")
var room11_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/2portas/dungeon_room_1.2.4.tscn")
var room12_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/2portas/dungeon_room_1.2.5.tscn")
var room13_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/2portas/dungeon_room_1.2.6.tscn")
#salas de 1 porta
var room14_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/1porta/dungeon_room_1.1.1.tscn")
var room15_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/1porta/dungeon_room_1.1.2.tscn")
var room16_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/1porta/dungeon_room_1.1.3.tscn")
var room17_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/1porta/dungeon_room_1.1.4.tscn")

#primeira sala
var first_room_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/dungeon_room_1.0.tscn")

func _ready():
	generate_dungeon()
	build_dungeon()
	
func generate_dungeon():
	var room_count = 0
	dungeon_layout = []

	for row in range(dungeon_size.y):
		var row_data = []
		for col in range(dungeon_size.x):
			var cell_value = 0 # 0 = sem sala  1 = sala normal
			if room_count < 5 and (randi() % 2 == 1):
				cell_value = 1
				room_count += 1
			row_data.append(cell_value)
		dungeon_layout.append(row_data) 
		
	# garantindo a entrada da dungeon no lugar q eu quero
	dungeon_layout[2][1] = 2 
	
	print("primeira dungeon")
	for row in dungeon_layout:
		print(row)
		
	# Garantindo que a primeira sala tenha conexões
	ensure_connectivity()
	print("Dungeon Conectada:")
	for row in dungeon_layout:
			print(row)
			
	print("Quantidade de salas:", room_count)
	
func ensure_connectivity():
	var start_pos = Vector2(1,2)
	var rooms = []
	
	for y in range(dungeon_size.y):
		for x in range (dungeon_size.x):
			if dungeon_layout[y][x] == 1 or dungeon_layout[y][x] == 2:
				rooms.append(Vector2(x,y))
				
	var visited = []
	var queue = [start_pos]
	
	while queue.size() > 0:
		var current = queue.pop_front()
		if current in visited:
			continue
		visited.append(current)
		
		var x = int(current.x)
		var y = int(current.y)
		
		var directions = [Vector2(0, -1), Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0)]
		for dir in directions:
			var nx = x + int(dir.x)
			var ny = y + int(dir.y)
			if nx >= 0 and nx < dungeon_size.x and ny >= 0 and ny < dungeon_size.y:
				if dungeon_layout[ny][nx] > 0 and Vector2(nx, ny) not in visited:
					queue.append(Vector2(nx, ny))
					
	for room in rooms:
		if room not in visited:
			print("Sala isolada encontrada em:", room)
			connect_room(int(room.x), int(room.y), visited)
			
	# Verificar novamente se todas as salas estão conectadas
	visited = []
	queue = [start_pos]
	
	while queue.size() > 0:
		var current = queue.pop_front()
		if current in visited:
			continue
		visited.append(current)
		
		var x = int(current.x)
		var y = int(current.y)
		
		var directions = [Vector2(0, -1), Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0)]
		for dir in directions:
			var nx = x + int(dir.x)
			var ny = y + int(dir.y)
			if nx >= 0 and nx < dungeon_size.x and ny >= 0 and ny < dungeon_size.y:
				if dungeon_layout[ny][nx] > 0 and Vector2(nx, ny) not in visited:
					queue.append(Vector2(nx, ny))
					
		for room in rooms:
			if room not in visited:
				print("Sala ainda isolada em:", room)
				# Conectar manualmente
				dungeon_layout[int(room.y)][int(room.x)] = 0  # Remover sala isolada
				print("Sala removida para garantir conectividade.")
		
	
	
func connect_room(x, y, visited):
	var directions = [Vector2(0, -1), Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0)]
	var possible_connections = []
	
	for dir in directions:
		var nx = x + int(dir.x)
		var ny = y + int(dir.y)
		
		if nx >= 0 and nx < dungeon_size.x and ny >= 0 and ny < dungeon_size.y:
			if dungeon_layout[ny][nx] > 0 and Vector2(nx, ny) in visited:
				possible_connections.append(Vector2(nx, ny))
		
	if possible_connections.size() > 0:
		var chosen_connection = possible_connections[randi() % possible_connections.size()]
		print("Conectando sala em (%d, %d) com sala em (%d, %d)" % [x, y, chosen_connection.x, chosen_connection.y])
		dungeon_layout[y][x] = 1
		dungeon_layout[int(chosen_connection.y)][int(chosen_connection.x)] = 1
		visited.append(Vector2(x, y))
	else:
		print("Não foi possível conectar a sala em (%d, %d)" % [x, y])
		dungeon_layout[y][x] = 0  # Remover sala isolada	
				
func build_dungeon():
	for row in range(dungeon_size.y):
		for col in range(dungeon_size.x):
			if dungeon_layout[row][col] > 0:
				var is_first_room = dungeon_layout[row][col] == 2
				build_room(col, row, is_first_room)
				
func build_room(x, y, is_first_room=false):
	var room_scene = first_room_scene if is_first_room else [room1_scene, room2_scene, room3_scene][randi() % 3]
	var room = room_scene.instantiate()
	add_child(room)
	room.position = Vector2(x * 640, y * 360)
	
	var has_top = y > 0 and dungeon_layout[y - 1][x] > 0
	var has_bottom = y < dungeon_size.y - 1 and dungeon_layout[y + 1][x] > 0
	var has_left = x > 0 and dungeon_layout[y][x - 1] > 0
	var has_right = x < dungeon_size.x - 1 and dungeon_layout[y][x + 1] > 0
	
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
		room.get_node("FireWallTop").play("topWall_open" if has_top else "topWall_closed")
		room.get_node("FireWallLeft").play("leftWall_open" if has_left else "leftWall_closed")
		room.get_node("FireWallRight").play("rightWall_open" if has_right else "rightWall_closed")
	else:
		room.get_node("FireWallBottom/StaticBody2D/WallBottomCollision").disabled = has_bottom
		room.get_node("FireWallBottom/StaticBody2D/DoorBottomCollision").disabled = not has_bottom
		room.get_node("FireWallBottom/StaticBody2D/DoorBottomCollision2").disabled = not has_bottom
		# Configura portas normais
		room.get_node("FireWallBottom").play("bottomWall_open" if has_bottom else "bottomWall_closed")
		room.get_node("FireWallTop").play("topWall_open" if has_top else "topWall_closed")
		room.get_node("FireWallLeft").play("leftWall_open" if has_left else "leftWall_closed")
		room.get_node("FireWallRight").play("rightWall_open" if has_right else "rightWall_closed")
