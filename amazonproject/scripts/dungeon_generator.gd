extends Node2D

var dungeon_size = Vector2(5, 5)
var dungeon_layout = [] #isso aqui vai armazenar o layout criado

var room_scene = preload("res://scenes/dungeon_room_1.tscn")
var first_room_scene = preload("res://scenes/dungeon_room_first.tscn")

func _ready():
	generate_dungeon()
	build_dungeon()
	
func generate_dungeon():

	for row in range(dungeon_size.y):
		var row_data = []
		for col in range(dungeon_size.x):
			var cell_value = randi() % 2 # 0 = sem sala  1 = sala normal
			row_data.append(cell_value)
		dungeon_layout.append(row_data) 
		
		
	# garantindo a entrada da dungeon no lugar q eu quero
	dungeon_layout[4][2] = 2 
	
	print("primeira dungeon")
	for row in dungeon_layout:
		print(row)
	
	#garantindo que a primeira sala tenha conexoes 
	var x = 2
	var y = 4
	
	var has_connection = false
	if y > 0 and dungeon_layout[y - 1][x] == 1: #cima
		has_connection = true
	if y < dungeon_size.y - 1 and dungeon_layout[y + 1][x] == 1: #baixo
		has_connection = true
	if x > 0 and dungeon_layout[y][x - 1] == 1: #esquerda
		has_connection = true
	if x < dungeon_size.x - 1 and dungeon_layout[y][x + 1] == 1: #direita
		has_connection = true
		
	if not has_connection:
		print("n houve conexao com a primeira sala")
		if y > 0: 
			dungeon_layout[y - 1][x] = 1
		elif y < dungeon_size.y - 1:
			dungeon_layout[y + 1][x] = 1
		elif x > 0:
			dungeon_layout[y][x - 1] = 1
		elif x < dungeon_size.x - 1:
			dungeon_layout[y][x + 1] = 1
		
		for row in dungeon_layout:
			print(row)
	
	
func build_dungeon():
	for row in range(dungeon_size.y):
		for col in range(dungeon_size.x):
			if dungeon_layout[row][col] > 0:
				var is_first_room = dungeon_layout[row][col] == 2
				build_room(col, row, is_first_room)
				


func build_room(x, y, is_first_room=false):
	var room = first_room_scene.instantiate() if is_first_room else room_scene.instantiate()
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
