extends Node2D

var dungeon_size = Vector2(5, 5)
var dungeon_layout = [] #isso aqui vai armazenar o layout criado

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
				
				var x = position.x
				var y = position.y
				
				#verifica se tem sala do lado
				var has_top = y > 0 and dungeon_layout[y - 1][x] == 1
				var has_bottom = y < dungeon_size.y - 1 and dungeon_layout[y + 1][x] == 1
				var has_left = x > 0 and dungeon_layout[y][x - 1] == 1
				var has_right = x < dungeon_size.x - 1 and dungeon_layout[y][x + 1] == 1
				
				var anim_player = room.get_node("FireWall")
				
				if has_top:
					anim_player.play("topWall_open")
				else:
					anim_player.play("topWall_closed")
					
				if has_bottom:
					anim_player.play("bottomWall_open")
				else:
					anim_player.play("bottomWall_closed")
					
				if has_left: 
					anim_player.play("leftWall_open")
				else:
					anim_player.play("leftWall_closed")
					
				if has_right:
					anim_player.play("rightWall_open")
				else: 
					anim_player.play("rightWall_closed")
				
				
func focus_on_room(col, row):
	$Camera2D.position = Vector2(col * 640 + 320, row * 360 + 180)
	
