extends TileMapLayer

var dungeon_size = Vector2(3, 3)
var dungeon_layout = []
var max_rooms = 5

#sala de 4 portas
var room_scene = preload("res://scenes/Dungeons/MataDaTerraFirme/1porta/dungeon_room_teste.tscn")

func _ready():
	generate_dungeon()
	build_dungeon()
	
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
	
	# Configuração das colisões das portas e paredes
	# Se há uma sala no topo, desativa a parede e ativa a porta, senão, mantém fechada
	room.get_node("Top/CollisionShape2D").disabled = has_top
	
	# Configuração para a parede e porta da esquerda
	room.get_node("Left/CollisionShape2D").disabled = has_left
	
	# Configuração para a parede e porta da direita
	room.get_node("Right/CollisionShape2D").disabled = has_right

	# Tratamento especial para a primeira sala
	if is_first_room:
		# A primeira sala sempre tem a saída aberta na parte de baixo
		room.get_node("Bottom/CollisionShape2D").disabled = true

	else:
		# Para as demais salas, ativamos ou desativamos portas e paredes conforme a necessidade
		room.get_node("Bottom/CollisionShape2D").disabled = has_bottom
		
		
func top_door_closed(tilemap: TileMapLayer):
	tilemap.set_cell(Vector2i(11,1),0,Vector2i(6,0))
	tilemap.set_cell(Vector2i(10,1),0,Vector2i(6,0))
	tilemap.set_cell(Vector2i(9,1),0,Vector2i(6,0))
	tilemap.set_cell(Vector2i(8,1),0,Vector2i(6,0))
	tilemap.set_cell(Vector2i(11,2),0,Vector2i(4,0))
	tilemap.set_cell(Vector2i(10,2),0,Vector2i(4,0))
	tilemap.set_cell(Vector2i(9,2),0,Vector2i(4,0))
	tilemap.set_cell(Vector2i(8,2),0,Vector2i(4,0))

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
			top_door_closed(tilemap)
			return room_scene
		"FFLF": 
			top_door_closed(tilemap)
			return room_scene
		 # 1 porta left
		"FFFR": 
			top_door_closed(tilemap)
			return room_scene # 1 porta right
		"FFLR": 
			top_door_closed(tilemap)
			return room_scene # 2 portas left right
		"TBFF": return room_scene  #2 portas top bot
		"TFFR": return room_scene  #2 portas top right
		"TFLF": return room_scene  #2 portas top left
		"FBFR": 
			top_door_closed(tilemap)
			return room_scene  #2 portas bot right
		"FBLF": 
			top_door_closed(tilemap)
			return room_scene  #2 portas bot left
		"TBFR": return room_scene  #3 portas top bot right
		"TBLF": return room_scene  #3 portas top bot left
		"TFLR": return room_scene  #3 portas top left right
		"FBLR":
			top_door_closed(tilemap)
			return room_scene  #3 portas bot left right
		_:
			# Se nenhuma correspondência exata for encontrada, escolhemos aleatoriamente entre três salas padrão
			return room_scene
		
		
