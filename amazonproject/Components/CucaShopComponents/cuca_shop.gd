extends Control

# Dicionário de poderes e seus preços
var poderes = {
	"chama_densa": {"button_path": "HBoxContainer/CurupiraVBox/ChamaDensaButton", "preco": 5},
	"explosao_ignea": {"button_path": "HBoxContainer/CurupiraVBox/ExplosaoIgneaButton", "preco": 8},
	"fogo_purificador": {"button_path": "HBoxContainer/CurupiraVBox/FogoPurificadorButton", "preco": 10},

	"maremoto": {"button_path": "HBoxContainer/IaraVBox/MaremotoButton", "preco": 6},
	"redemoinho": {"button_path": "HBoxContainer/IaraVBox/RedemoinhoButton", "preco": 8},
	"aguas_revigorantes": {"button_path": "HBoxContainer/IaraVBox/AguasRevigorantesButton", "preco": 10},

	"facho_triplo": {"button_path": "HBoxContainer/BoitataVBox/FachoTriploButton", "preco": 6},
	"luz_cega": {"button_path": "HBoxContainer/BoitataVBox/LuzCegaButton", "preco": 9},
	"chama_espiritual": {"button_path": "HBoxContainer/BoitataVBox/ChamaEspiritualButton", "preco": 12}
}

# Armazena referência dos botões (para fácil acesso)
var botoes = {}

func _ready() -> void:
	# Carrega referências e conecta sinais de todos os botões dinamicamente
	for poder_name in poderes.keys():
		var button_path = poderes[poder_name]["button_path"]
		var button = get_node(button_path)
		botoes[poder_name] = button
		
		# Conecta todos os botões a uma função genérica
		button.pressed.connect(func(): comprar_poder(poder_name))
		

func desativar_button(button: Button):
	button.disabled = true
	button.modulate.a = 0.5

func comprar_poder(poder_name: String):
	var preco = poderes[poder_name]["preco"]
	var button = botoes[poder_name]

	# Verifica se o jogador tem moedas suficientes
	if PlayerInventory.coins < preco:
		print("Moedas insuficientes para comprar ", poder_name)
		return

	# Remove moedas e registra poder
	PlayerInventory.remove_coins(preco)
	print("Poder comprado: ", poder_name)

	# Desativa o botão na loja
	desativar_button(button)

	# Chama função placeholder que futuramente aplicará o efeito do poder
	aplicar_poder_no_player(poder_name)

func aplicar_poder_no_player(poder_name: String):
	# 🚧 Função para implementar futuramente
	# Aqui você aplicaria o efeito da melhoria no player
	# Exemplo:
	# match poder_name:
	#   "chama_densa":
	#       player.fire_damage += 10
	#   "maremoto":
	#       player.unlock_ability("Maremoto")
	# etc.
	pass

func _on_sair_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/aldeia.tscn")
