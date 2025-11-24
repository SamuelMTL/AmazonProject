extends Control

@onready var carteira = $Dinheiro
@onready var descricao = $Descricao
@onready var botao_comprar = $Comprar
# Dicionário de poderes e seus preços
var poderes = {
	"chama_densa": {"button_path": "HBoxContainer/CurupiraVBox/ChamaDensaButton", "preco": 5, "descricao": "Aumenta o tempo de duração do fogo"},
	"explosao_ignea": {"button_path": "HBoxContainer/CurupiraVBox/ExplosaoIgneaButton", "preco": 8, "descricao": "Ao final do rastro, ocorre uma explosão de dano em área"},
	"fogo_purificador": {"button_path": "HBoxContainer/CurupiraVBox/FogoPurificadorButton", "preco": 10, "descricao": "Inimigos derrotados pelo fogo deixam recursos extras"},

	"maremoto": {"button_path": "HBoxContainer/IaraVBox/MaremotoButton", "preco": 6, "descricao": "A onda passa a causar dano além do empurrão"},
	"redemoinho": {"button_path": "HBoxContainer/IaraVBox/RedemoinhoButton", "preco": 8, "descricao": "Cria um vórtice de água que prende inimigos temporariamente" },
	"aguas_revigorantes": {"button_path": "HBoxContainer/IaraVBox/AguasRevigorantesButton", "preco": 10, "descricao": "Ao usar a habilidade, Caipora recupera uma pequena parte da vida"},

	"facho_triplo": {"button_path": "HBoxContainer/BoitataVBox/FachoTriploButton", "preco": 6, "descricao": "Dispara três feixes em leque"},
	"luz_cega": {"button_path": "HBoxContainer/BoitataVBox/LuzCegaButton", "preco": 9, "descricao": "Além de dano, a rajada deixa inimigos próximos atordoados"},
	"chama_espiritual": {"button_path": "HBoxContainer/BoitataVBox/ChamaEspiritualButton", "preco": 12, "descricao": "Reduz o tempo de recarga da habilidade ao derrotar inimigos"}
}

# Armazena referência dos botões (para fácil acesso)
var botoes = {}
var poder_selecionado: String = ""

func _ready() -> void:
	atualizar_carteira()
	descricao.text = "Selecione uma melhoria para ver detalhes."
	botao_comprar.disabled = true  # desativa o botão de compra até que um poder seja selecionado
	
	# Conecta botões dinamicamente
	for poder_name in poderes.keys():
		var button_path = poderes[poder_name]["button_path"]
		var button = get_node(button_path)
		botoes[poder_name] = button
		
		# Conecta a função que exibe a descrição
		button.pressed.connect(func(): selecionar_poder(poder_name))
	
	# Conecta o botão de compra
	botao_comprar.pressed.connect(_on_comprar_pressed)
		
func atualizar_carteira():
	carteira.text = str(PlayerInventory.coins)
	
func desativar_button(button: Button):
	button.disabled = true
	button.modulate.a = 0.5
	
func selecionar_poder(poder_name: String):
	var info = poderes[poder_name]
	poder_selecionado = poder_name
	
	descricao.text =  poder_name.capitalize().replace("_", " ") + "\n" \
	+ info["descricao"] + "\n\nPreço: " + str(info["preco"]) + " moedas"
	descricao.bbcode_enabled = true
	
	botao_comprar.disabled = false  # ativa o botão de compra

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
	atualizar_carteira()

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


func _on_comprar_pressed() -> void:
	if poder_selecionado == "":
		return  # segurança extra
	
	var preco = poderes[poder_selecionado]["preco"]
	var button = botoes[poder_selecionado]

	# Verifica moedas
	if PlayerInventory.coins < preco:
		descricao.text = "[color=red]Moedas insuficientes para comprar este poder![/color]"
		descricao.bbcode_enabled = true
		return

	# Faz a compra
	PlayerInventory.remove_coins(preco)
	atualizar_carteira()

	# Desativa o botão da melhoria comprada
	desativar_button(button)
	botao_comprar.disabled = true
	print("Poder comprado: ", poder_selecionado)

	# Mostra mensagem de sucesso
	descricao.text = "[color=green]" + poder_selecionado.capitalize().replace("_", " ") + " adquirido![/color]"
	descricao.bbcode_enabled = true

	# Placeholder para aplicar o efeito
	aplicar_poder_no_player(poder_selecionado)
