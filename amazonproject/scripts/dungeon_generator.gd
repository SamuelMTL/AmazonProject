extends Node2D

var dungeon_size = Vector2(5, 5)
var dungeon_layout = [] #isso aqui vai armazenar o layout criado
var max_rooms = 10
var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

var room_scene = preload("res://scenes/dungeon_room_1.tscn")

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
		print(row_data)
	
	# garantindo a entrada da dungeon no lugar q eu quero
	dungeon_layout[4][2] = 1 

func build_dungeon():
	for row in range(dungeon_size.y):
		for col in range(dungeon_size.x):
			if dungeon_layout[row][col] == 1:
				var room = room_scene.instantiate()
				add_child(room)
				room.position = Vector2(col * 640, row * 360)
				
				var x = col
				var y = row
				
				#verifica se tem sala do lado
				var has_top = y > 0 and dungeon_layout[y - 1][x] == 1
				var has_bottom = y < dungeon_size.y - 1 and dungeon_layout[y + 1][x] == 1
				var has_left = x > 0 and dungeon_layout[y][x - 1] == 1
				var has_right = x < dungeon_size.x - 1 and dungeon_layout[y][x + 1] == 1

				room.get_node("FireWallCorners").play("fire_corners")
				#garante que a porta da entrada esteja aberta
				if row == 4 and col == 2:
					room.get_node("FireWallBottom").play("bottomWall_open")
				else:
					room.get_node("FireWallBottom").play("bottomWall_open" if has_bottom else "bottomWall_closed")
					
				room.get_node("FireWallTop").play("topWall_open" if has_top else "topWall_closed")
				room.get_node("FireWallLeft").play("leftWall_open" if has_left else "leftWall_closed")
				room.get_node("FireWallRight").play("rightWall_open" if has_right else "rightWall_closed")
				
				
