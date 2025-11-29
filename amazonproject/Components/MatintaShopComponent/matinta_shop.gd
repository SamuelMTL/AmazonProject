extends Control

@onready var vender_button = $TextureRect/VBoxContainer/HBoxContainer/VBoxContainer/VenderButton
@onready var comprar_button = $TextureRect/VBoxContainer/HBoxContainer/VBoxContainer2/ComprarButton
@onready var armas_button = $TextureRect/VBoxContainer/ComprarContainer/HBoxContainer/ArmasButton
@onready var armaduras_button = $TextureRect/VBoxContainer/ComprarContainer/HBoxContainer/ArmadurasButton

@onready var vender_container = $TextureRect/VBoxContainer/VenderContainer
@onready var comprar_container = $TextureRect/VBoxContainer/ComprarContainer
@onready var vender_vbox = $TextureRect/VBoxContainer/VenderContainer/ScrollContainer/VenderVBoxContainer

@onready var armaduras_container = $TextureRect/VBoxContainer/ComprarContainer/ArmadurasScrollContainer
@onready var armas_container = $TextureRect/VBoxContainer/ComprarContainer/ArmasScrollContainer
@onready var armaduras_vbox = $TextureRect/VBoxContainer/ComprarContainer/ArmadurasScrollContainer/ArmadurasVBoxContainer
@onready var armas_vbox = $TextureRect/VBoxContainer/ComprarContainer/ArmasScrollContainer/ArmasVBoxContainer

@onready var shop_item_scene = preload("res://Components/MatintaShopComponent/ShopItemComponent.tscn")

@onready var carteira = $Carteira

@onready var buy_sound = $"BuySound"
@onready var sell_sound = $"SellSound"

var collectibles_prices = {
	"Resina Ancestral": 2,
	"Fragmentos de Cipó-Sagrado": 3,
	"Cristais de Seiva": 10,
	"Flores da Lua": 7,
	"Cinzas do Curupira": 8,
	"Penas do Uirapuru": 12,
	"Orvalho de Jiboia Encantada": 6,
	"Raiz de Iara": 9,
	"Luzes de Fogo-Fatuo": 4,
	"Areia do Tempo Parado": 5,
	"Lagrimas de Boto": 11,
	"Petalas da Vitoria-Regia": 7,
	"Esporos de Fungos-Ancestrais": 3,
	"Sementes do Pequi-Espiritual": 6,
	"Poeira de Ossos de Mapinguari": 14
}

var weapons_prices = {
	"Lança de Madeira Petrificada": 50,
	"Boleadeira de Cipó": 50,
	"Zarabatana Espiritual": 40
}

var armors_prices = {
	"Capa de Folhagem Viva": 20,
	"Peitoral de Casca de Samaúma": 30,
	"Botas de Borracha Natural": 20
}

func _ready() -> void:
	gerar_itens_loja(weapons_prices, armas_vbox, "weapon")
	gerar_itens_loja(armors_prices, armaduras_vbox, "armor")
	gerar_itens_venda()
	mostrar_itens_correspondentes()
	atualizar_carteira()
	
func gerar_itens_loja(itens: Dictionary, container: VBoxContainer, tipo: String):
	for nome in itens.keys():
		var preco = itens[nome]
		var item_instance = shop_item_scene.instantiate()
		
		container.add_child(item_instance)
		item_instance.shop_manager = self
		item_instance.setup(nome, preco, tipo)

func gerar_itens_venda():
	# Limpa a lista antiga
	for child in vender_vbox.get_children():
		child.queue_free()

	# Gera novamente com base no inventário atual
	for nome in PlayerInventory.collectibles.keys():
		var dados = PlayerInventory.collectibles[nome]
		var quantidade = dados["quantidade"]
		var preco_unitario = dados["preco"]
		var preco_total = preco_unitario * quantidade

		var item_instance = shop_item_scene.instantiate()
		vender_vbox.add_child(item_instance)
		item_instance.shop_manager = self

		# Exibe nome + quantidade
		item_instance.setup("%s (x%d)" % [nome, quantidade], preco_unitario, "sell_collectible", nome)
		item_instance.item_name = nome

		# Se o jogador não tiver mais quantidade, desativa
		if quantidade <= 0:
			item_instance.desativar_item()

func sell_collectible(item_name: String, amount: int):
	if not PlayerInventory.collectibles.has(item_name):
		return false

	var dados = PlayerInventory.collectibles[item_name]
	if dados["quantidade"] < amount:
		return false

	var preco_unitario = collectibles_prices.get(item_name, dados["preco"])
	var total_price = preco_unitario * amount

	PlayerInventory.remove_collectible(item_name, amount)
	PlayerInventory.add_coins(preco_unitario)
	
	sell_sound.play()

	# Atualiza visualmente os itens de venda
	gerar_itens_venda()
	atualizar_carteira()
	return true

	
func buy_weapon(weapon_name: String):
	var price = weapons_prices.get(weapon_name, -1)
	if price == -1:
		return false
	
	if PlayerInventory.remove_coins(price):
		buy_sound.play()
		PlayerInventory.add_weapon(weapon_name)
		atualizar_carteira()
		return true
	return false
	
func buy_armor(armor_name: String):
	var price = armors_prices.get(armor_name, -1)
	if price == -1:
		return false
	
	if PlayerInventory.remove_coins(price):
		buy_sound.play()
		PlayerInventory.add_armor(armor_name)
		atualizar_carteira()
		return true
	return false


func _on_vender_button_pressed() -> void:
	vender_button.button_pressed = true
	comprar_button.button_pressed = false
	mostrar_itens_correspondentes()


func _on_comprar_button_pressed() -> void:
	vender_button.button_pressed = false
	comprar_button.button_pressed= true
	mostrar_itens_correspondentes()


func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/aldeia.tscn")
	
func mostrar_itens_correspondentes():
	if vender_button.button_pressed == true and comprar_button.button_pressed == false:
		vender_container.visible = true
		comprar_container.visible = false
	elif vender_button.button_pressed == false and comprar_button.button_pressed == true:
		vender_container.visible = false
		comprar_container.visible = true
		
		if armaduras_button.button_pressed == true and armas_button.button_pressed == false:
			armaduras_container.visible = true
			armas_container.visible = false
		elif armaduras_button.button_pressed == false and armas_button.button_pressed == true:
			armaduras_container.visible = false
			armas_container.visible = true
		else:
			corrigir_botoes()
	else:
		corrigir_botoes() 
		
func corrigir_botoes():
	vender_button.button_pressed = true
	comprar_button.button_pressed = false


func _on_armaduras_button_pressed() -> void:
	armaduras_button.button_pressed = true
	armas_button.button_pressed = false
	mostrar_itens_correspondentes()


func _on_armas_button_pressed() -> void:
	armaduras_button.button_pressed = false
	armas_button.button_pressed = true
	mostrar_itens_correspondentes()
	
func atualizar_carteira():
	carteira.text = str(PlayerInventory.coins)
