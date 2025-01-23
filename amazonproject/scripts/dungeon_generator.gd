extends Node2D

var dungeon_size = Vector2(5, 5)
var dungeon_layout = [] #isso aqui vai armazenar o layout criado

var room_scene = preload("res://scenes/dungeon_room_1.tscn")

func _ready():
	generate_dungeon()
	
func generate_dungeon():
	for row in range(dungeon_size.y):
		var row_data = []
		for col in range(dungeon_size.x):
			var cell_value = randi() % 2 # 0 = sem sala   1 = sala normal
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
				
func focus_on_room(col, row):
	$Camera2D.position = Vector2(col * 640 + 320, row * 360 + 180)
			
