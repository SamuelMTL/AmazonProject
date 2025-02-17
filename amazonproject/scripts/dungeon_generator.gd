extends Node2D

var dungeon_size = Vector2(3, 3)
var dungeon_layout = []
var max_rooms = 5

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
				
# Função principal que percorre a matriz da dungeon e constrói as salas
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
	# Escolhe a cena da sala correta baseado nas conexões
	var room_scene = first_room_scene if is_first_room else get_room_by_connections(num_connections, has_top, has_bottom, has_left, has_right)
	
	# Instancia a sala no jogo e a adiciona ao mapa
	var room = room_scene.instantiate()
	add_child(room)
	# Define a posição da sala no mundo do jogo
	room.position = Vector2(x * 640, y * 360)
	
	# Configuração das colisões das portas e paredes
	# Se há uma sala no topo, desativa a parede e ativa a porta, senão, mantém fechada
	room.get_node("FireWallTop/StaticBody2D/WallTopCollision").disabled = has_top
	room.get_node("FireWallTop/StaticBody2D/DoorTopCollision").disabled = not has_top
	room.get_node("FireWallTop/StaticBody2D/DoorTopCollision2").disabled = not has_top
	
	# Configuração para a parede e porta da esquerda
	room.get_node("FireWallLeft/StaticBody2D/WallLeftCollision").disabled = has_left
	room.get_node("FireWallLeft/StaticBody2D/DoorLeftCollision").disabled = not has_left
	room.get_node("FireWallLeft/StaticBody2D/DoorLeftCollision2").disabled = not has_left
	
	# Configuração para a parede e porta da direita
	room.get_node("FireWallRight/StaticBody2D/WallRightCollision").disabled = has_right
	room.get_node("FireWallRight/StaticBody2D/DoorRightCollision").disabled = not has_right
	room.get_node("FireWallRight/StaticBody2D/DoorRightCollision2").disabled = not has_right
	
	# Ativa a animação das chamas nas esquinas das paredes
	room.get_node("FireWallCorners").play("fire_corners")
	
	# Tratamento especial para a primeira sala
	if is_first_room:
		# A primeira sala sempre tem a saída aberta na parte de baixo
		room.get_node("FireWallBottom/StaticBody2D/WallBottomCollision").disabled = true
		room.get_node("FireWallBottom/StaticBody2D/DoorBottomCollision").disabled = false
		room.get_node("FireWallBottom/StaticBody2D/DoorBottomCollision2").disabled = false
		# Configuração da animação para manter a parte de baixo aberta
		room.get_node("FireWallBottom").play("bottomWall_open")
	else:
		# Para as demais salas, ativamos ou desativamos portas e paredes conforme a necessidade
		room.get_node("FireWallBottom/StaticBody2D/WallBottomCollision").disabled = has_bottom
		room.get_node("FireWallBottom/StaticBody2D/DoorBottomCollision").disabled = not has_bottom
		room.get_node("FireWallBottom/StaticBody2D/DoorBottomCollision2").disabled = not has_bottom
		# Controlamos a animação da parede inferior
		room.get_node("FireWallBottom").play("bottomWall_open" if has_bottom else "bottomWall_closed")
		
	# Define as animações das outras paredes conforme as conexões da sala
	room.get_node("FireWallTop").play("topWall_open" if has_top else "topWall_closed")
	room.get_node("FireWallLeft").play("leftWall_open" if has_left else "leftWall_closed")
	room.get_node("FireWallRight").play("rightWall_open" if has_right else "rightWall_closed")

# Função que escolhe a cena da sala com base nas conexões que ela tem
func get_room_by_connections(num_connections, has_top, has_bottom, has_left, has_right):
	# Criamos um código de conexão baseado na presença de salas vizinhas
	var connection_pattern = ""
	connection_pattern += "T" if has_top else "F"
	connection_pattern += "B" if has_bottom else "F"
	connection_pattern += "L" if has_left else "F"
	connection_pattern += "R" if has_right else "F"
	
	# Comparamos esse padrão com diferentes possibilidades para escolher a sala correta
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
		"TBLF": return room5_scene #3 portas top bot left
		"TFLR": return room6_scene #3 portas top left right
		"FBLR": return room7_scene #3 portas bot left right
		_:
			# Se nenhuma correspondência exata for encontrada, escolhemos aleatoriamente entre três salas padrão
			return [room1_scene, room2_scene, room3_scene][randi() % 3]
		
		
