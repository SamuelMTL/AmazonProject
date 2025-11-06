extends Control

@onready var vender_button = $TextureRect/VBoxContainer/HBoxContainer/VBoxContainer/VenderButton
@onready var comprar_button = $TextureRect/VBoxContainer/HBoxContainer/VBoxContainer2/ComprarButton
@onready var armas_button = $TextureRect/VBoxContainer/ComprarContainer/HBoxContainer/ArmasButton
@onready var armaduras_button = $TextureRect/VBoxContainer/ComprarContainer/HBoxContainer/ArmadurasButton

@onready var vender_container = $TextureRect/VBoxContainer/VenderContainer
@onready var comprar_container = $TextureRect/VBoxContainer/ComprarContainer

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

func sell_collectible(item_name: String, amount: int):
	if not PlayerInventory.collectibles.has(item_name):
		return false
	
	if PlayerInventory.collectibles[item_name] < amount:
		return false
	
	# Calcula preço
	var total_price = collectibles_prices.get(item_name, 0) * amount
	
	PlayerInventory.remove_collectible(item_name, amount)
	PlayerInventory.add_coins(total_price)
	return true
	
func buy_weapon(weapon_name: String):
	var price = weapons_prices.get(weapon_name, -1)
	if price == -1:
		return false
	
	if PlayerInventory.remove_coins(price):
		PlayerInventory.add_weapon(weapon_name)
		return true
	return false
	
func buy_armor(armor_name: String):
	var price = armors_prices.get(armor_name, -1)
	if price == -1:
		return false
	
	if PlayerInventory.remove_coins(price):
		PlayerInventory.add_armor(armor_name)
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
	else:
		corrigir_botoes() 
		
func corrigir_botoes():
	vender_button.button_pressed = true
	comprar_button.button_pressed = false
