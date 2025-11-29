extends TileMapLayer

var dungeon_size = Vector2(3, 3)
var dungeon_layout = []
var max_rooms = 5

#sala de 4 portas
var room_scene = preload("res://Scenes/Dungeons/MataDaTerraFirme/DungeonRoomMTF.tscn")
var inimigo = preload("res://inimigoteste.tscn")

var enemies_room = {} 
var room_num = 0
var rooms = {}  # salva cada sala instanciada

func _ready():
	generate_dungeon()
	build_dungeon()
	
	
func _process(delta: float) -> void:
	if Global.enemy_counter == 0:
		boss_room()
		
	
	
func generate_dungeon():
	var size = 3
	dungeon_layout = []  # Reinicializa a matriz
	
	# Cria uma matriz 3x3 preenchida com zeros (0), representando espaços vazios
	for i in range(size):
		dungeon_layout.append([])
		for j in range(size):
			dungeon_layout[i].append(0)
			
	# Lista de direções possíveis (cima, baixo, direita, esquerda)	
	var directions = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]
	# Lista para armazenar as salas já criadas e garantir que estejam conectadas
	var visited = []
	
	# Define o ponto inicial fixo (1, 2)
	var start_x = 2
	var start_y = 1
	dungeon_layout[start_x][start_y] = 2 # Marca essa sala inicial com o valor 2
	visited.append(Vector2(start_x, start_y)) # Adiciona a sala inicial à lista de visitados
	
	# Expande o mapa aleatoriamente até atingir o número máximo de salas (max_rooms)
	while len(visited) <= max_rooms:
		# Escolhe aleatoriamente uma das salas já visitadas para expandir
		var current_pos = visited[randi() % len(visited)]
		directions.shuffle()  # Embaralha direções para caminhos variados
		
		for dir in directions:
			var new_x = current_pos.x + dir.x
			var new_y = current_pos.y + dir.y
			
			# Verifica se a nova posição está dentro dos limites da matriz e se ainda não foi ocupada
			if new_x >= 0 and new_x < size and new_y >= 0 and new_y < size and dungeon_layout[new_x][new_y] == 0:
				dungeon_layout[new_x][new_y] = 1
				visited.append(Vector2(new_x, new_y))
				break  # Garante que estamos expandindo um caminho válido
				
	for row in dungeon_layout:
		print(row)
				
func build_dungeon():
	# Percorre cada linha da matriz da dungeon
	for row in range(dungeon_size.y):
		# Percorre cada coluna da matriz da dungeon
		for col in range(dungeon_size.x):
			# Se a célula atual for maior que 0, significa que há uma sala aqui
			if dungeon_layout[row][col] > 0:
				# Verifica se esta é a sala inicial
				var is_first_room = dungeon_layout[row][col] == 2
				# Chama a função para construir a sala na posição correspondente
				build_room(col, row, is_first_room)
				
# Função que constrói visualmente cada sala baseada no layout gerado
func build_room(x, y, is_first_room=false):
	# Verifica se há conexões com salas vizinhas
	var has_top = y > 0 and dungeon_layout[y - 1][x] > 0
	var has_bottom = y < dungeon_size.y - 1 and dungeon_layout[y + 1][x] > 0
	var has_left = x > 0 and dungeon_layout[y][x - 1] > 0
	var has_right = x < dungeon_size.x - 1 and dungeon_layout[y][x + 1] > 0
	
	
	# Conta quantas conexões essa sala possui
	var num_connections = int(has_top) + int(has_bottom) + int(has_left) + int(has_right)
	
	var room_scene = room_scene
	
	# Instancia a sala no jogo e a adiciona ao mapa
	var room = room_scene.instantiate()
	add_child(room)
	
	var tilemaplayer = room.get_node("MataDeTerraFirmeTilemap")
	get_room_by_connections(num_connections, has_top, has_bottom, has_left, has_right, tilemaplayer)
	
	# Define a posição da sala no mundo do jogo
	room.position = Vector2(x * 640, y * 360)
	
	room.has_top = has_top
	room.has_bottom = has_bottom
	room.has_left = has_left
	room.has_right = has_right
	
	
	var bottom_animations = room.get_node("BottomDoor")
	var left_animations = room.get_node("LeftDoor")
	var right_animations = room.get_node("RightDoor")
	
	room_num += 1
	enemies_room[room_num] = 1  # sala começa com 1 inimigo
	room.room_id = room_num 
	
	spawn_enemy(room, 3)
	
	room.dungeon_controller = self
	rooms[room_num] = room
	
	room.get_node("Top/CollisionShape2D").disabled = true
	
	room.get_node("Left/CollisionShape2D").disabled = true
	
	room.get_node("Right/CollisionShape2D").disabled = true

	# Tratamento especial para a primeira sala
	if is_first_room:
		room.get_node("Area2D/CollisionShape2D").disabled = true
		room.get_node("Top/CollisionShape2D").disabled = false
		room.get_node("Left/CollisionShape2D").disabled = false
		room.get_node("Right/CollisionShape2D").disabled = false
		room.get_node("Bottom/CollisionShape2D").disabled = false
		bottom_animations.play("bottomDoor")
		left_animations.play("leftDoor")
		right_animations.play("rightDoor")
		

	else:
		# Para as demais salas, ativamos ou desativamos portas e paredes conforme a necessidade
		room.get_node("Bottom/CollisionShape2D").disabled = has_bottom
		
		


# Função que escolhe a cena da sala com base nas conexões que ela tem
func get_room_by_connections(num_connections, has_top, has_bottom, has_left, has_right, tilemap: TileMapLayer):
	# Criamos um código de conexão baseado na presença de salas vizinhas
	var connection_pattern = ""
	connection_pattern += "T" if has_top else "F"
	connection_pattern += "B" if has_bottom else "F"
	connection_pattern += "L" if has_left else "F"
	connection_pattern += "R" if has_right else "F"
	
	# Comparamos esse padrão com diferentes possibilidades para escolher a sala correta
	match connection_pattern:
		"TFFF": 
			
			return room_scene # 1 porta top
		"FBFF": #1 porta bottom
			
			return room_scene
		"FFLF": 
			
			return room_scene
		 # 1 porta left
		"FFFR": 
			
			return room_scene # 1 porta right
		"FFLR": 
			
			return room_scene # 2 portas left right
		"TBFF":
			
			return room_scene  #2 portas top bot
		"TFFR": 
			
			return room_scene  #2 portas top right
		"TFLF":
			 
			return room_scene  #2 portas top left
		"FBFR": 
			
			return room_scene  #2 portas bot right
		"FBLF": 
			
			return room_scene  #2 portas bot left
		"TBFR":
			
			return room_scene  #3 portas top bot right
		"TBLF":
			
			return room_scene  #3 portas top bot left
		"TFLR":
			 
			return room_scene  #3 portas top left right
		"FBLR":
			
			return room_scene  #3 portas bot left right
		_:
			# Se nenhuma correspondência exata for encontrada, escolhemos aleatoriamente entre três salas padrão
			return room_scene
		
func spawn_enemy(room, quantidade := 1):
	for i in range(quantidade):
		var enemy = inimigo.instantiate()
		add_child(enemy)

		var offset = Vector2(randf_range(-100, 100), randf_range(-100, 100))
		enemy.position = room.position + Vector2(320, 180) + offset
		enemy.room_id = room.room_id    

		Global.enemy_counter += 1
		enemy.connect("died", Callable(self, "enemy_died"))

		print("Inimigo spawnado em: ", enemy.position, " | total inimigos: ", Global.enemy_counter)

func boss_room():
	get_tree().change_scene_to_file("res://Scenes/Dungeons/MataDaTerraFirme/BossRoom.tscn")

func enemy_died(room_id):
	print("Enemy died in room:", room_id)
	print("enemies_room keys:", enemies_room.keys())

	enemies_room[room_id] -= 1

	if enemies_room[room_id] <= 0:
		open_doors_of_room(room_id)
		
func open_doors_of_room(room_id):
	var room = rooms[room_id]

	# só abre portas que realmente existem!
	if room.has_top:
		room.get_node("Top/CollisionShape2D").disabled = true
		room.get_node("TopDoor").play("open")

	if room.has_bottom:
		room.get_node("Bottom/CollisionShape2D").disabled = true
		room.get_node("BottomDoor").play("open")

	if room.has_left:
		room.get_node("Left/CollisionShape2D").disabled = true
		room.get_node("LeftDoor").play("open")

	if room.has_right:
		room.get_node("Right/CollisionShape2D").disabled = true
		room.get_node("RightDoor").play("open")
	
func close_doors_of_room(room_id):
	var room = rooms[room_id]
	
	# Fechar colisões
	room.get_node("Top/CollisionShape2D").disabled = false
	room.get_node("Bottom/CollisionShape2D").disabled = false
	room.get_node("Left/CollisionShape2D").disabled = false
	room.get_node("Right/CollisionShape2D").disabled = false

	
	room.get_node("TopDoor").play("close")
	room.get_node("BottomDoor").play("close")
	room.get_node("LeftDoor").play("close")
	room.get_node("RightDoor").play("close")
	
func player_entered_room(room_id):
	var room = rooms[room_id]

	if room.already_entered:
		return  # evita repetir animações / lógica
		
	room.already_entered = true  # marca como visitada
	
	close_doors_of_room(room_id)
