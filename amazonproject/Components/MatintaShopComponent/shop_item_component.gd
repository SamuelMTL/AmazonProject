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
	
func setup(nome: String, preco: int, tipo: String):
	item_name = nome
	item_price = preco
	item_type = tipo
	
	item_name_label.text = nome
	item_price_label.text = "$ " + str(preco)


func _on_texture_button_pressed() -> void:
	var sucesso = false

	if item_type == "weapon":
		sucesso = shop_manager.buy_weapon(item_name)
	elif item_type == "armor":
		sucesso = shop_manager.buy_armor(item_name)
	
	if sucesso:
		# Desabilita o botão e reduz opacidade do item
		buy_button.disabled = true
		modulate.a = 0.5
	else:
		# Aqui você pode tocar um som de erro ou exibir uma mensagem
		print("Compra falhou: moedas insuficientes ou item inválido.")
