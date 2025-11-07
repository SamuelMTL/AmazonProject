extends Control

@onready var item_name_label = $HBoxContainer/TextureRect/ItemName
@onready var item_price_label = $HBoxContainer/TextureButton/ItemPrice
@onready var buy_button = $HBoxContainer/TextureButton

var item_name: String
var item_price: int
var item_type: String

var shop_manager

func _ready() -> void:
	buy_button.pressed.connect(_on_texture_button_pressed)
	
func setup(nome: String, preco: int, tipo: String, real_name: String = ""):
	item_name = real_name if real_name != "" else nome
	item_price = preco
	item_type = tipo
	
	item_name_label.text = nome
	item_price_label.text = "$ " + str(preco)
	
	match item_type:
		"weapon":
			if PlayerInventory.weapons.has(item_name):
				desativar_item()
		"armor":
			if PlayerInventory.armors.has(item_name):
				desativar_item()
		"sell_collectible":
			if not PlayerInventory.collectibles.has(item_name) or PlayerInventory.collectibles[item_name]["quantidade"] <= 0:
				desativar_item()

func _on_texture_button_pressed() -> void:
	if shop_manager == null:
		return  
		
	var sucesso = false

	match item_type:
		"weapon":
			sucesso = shop_manager.buy_weapon(item_name)
		"armor":
			sucesso = shop_manager.buy_armor(item_name)
		"sell_collectible":
			sucesso = shop_manager.sell_collectible(item_name, 1)
	
	if sucesso:
		# Atualiza o texto do nome e preço (caso ainda exista o item)
		if item_type == "sell_collectible" and PlayerInventory.collectibles.has(item_name):
			var dados = PlayerInventory.collectibles[item_name]
			var nova_qtd = dados["quantidade"]
			if nova_qtd > 0:
				item_name_label.text = "%s (x%d)" % [item_name, nova_qtd]
				item_price_label.text = "$ " + str(dados["preco"] * nova_qtd)
			else:
				desativar_item()
		else:
			desativar_item()
	else:
		print("Compra/Venda falhou: moedas insuficientes ou item inválido.")

func desativar_item():
	buy_button.disabled = true
	modulate.a = 0.5
